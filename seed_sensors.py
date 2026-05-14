#!/usr/bin/env python3
"""
Fake sensor data generator for cave_sensor_readings.

Usage:
    python seed_sensors.py                # 30 days of history
    python seed_sensors.py --days 7       # 7 days of history
    python seed_sensors.py --clear        # wipe readings, then seed
    python seed_sensors.py --live         # seed 24h then stream live every 10s
    python seed_sensors.py --live --interval 5
"""
import argparse
import math
import os
import random
import time
from datetime import datetime, timezone, timedelta

import psycopg

DB_URL = (
    f"postgresql://{os.getenv('DB_USER', 'admin')}:"
    f"{os.getenv('DB_PASSWORD', 'admin')}@"
    f"{os.getenv('DB_HOST', 'localhost')}:"
    f"{os.getenv('DB_PORT', '5432')}/"
    f"{os.getenv('DB_NAME', 'cavesdb')}"
)

INTERVAL_MINUTES = 10

# Physical characteristics per sensor code
PROFILES = {
    'SEN-DOMICA-01': {
        'base_temp':        10.2,
        'temp_amplitude':    0.8,   # seasonal swing °C
        'base_humidity':    95.0,
        'base_co2':          720,
        'co2_visitor_peak':  350,   # extra ppm during opening hours
    },
    'SEN-JASOV-01': {
        'base_temp':         9.1,
        'temp_amplitude':    0.6,
        'base_humidity':    92.0,
        'base_co2':          680,
        'co2_visitor_peak':  280,
    },
    'SEN-HARMAN-01': {
        'base_temp':         7.8,
        'temp_amplitude':    1.1,
        'base_humidity':    88.0,
        'base_co2':          750,
        'co2_visitor_peak':  420,
    },
}


def _visitor_hour(dt: datetime) -> bool:
    return 9 <= dt.hour < 17


def generate_reading(code: str, dt: datetime, prev: dict | None) -> dict:
    p = PROFILES[code]
    day_of_year = dt.timetuple().tm_yday
    seasonal = p['temp_amplitude'] * math.sin((day_of_year - 80) * 2 * math.pi / 365)

    if prev:
        temp     = prev['temperature'] + random.gauss(0, 0.05)
        humidity = prev['humidity']    + random.gauss(0, 0.10)
        co2      = prev['co2']         + random.gauss(0, 8)
    else:
        temp     = p['base_temp']     + seasonal + random.gauss(0, 0.1)
        humidity = p['base_humidity'] + random.gauss(0, 0.5)
        co2      = p['base_co2']      + random.gauss(0, 20)

    # slow mean reversion so values don't drift away over time
    temp     = temp * 0.98  + (p['base_temp'] + seasonal) * 0.02
    humidity = humidity * 0.97 + p['base_humidity'] * 0.03

    visitor_boost = p['co2_visitor_peak'] if _visitor_hour(dt) else 0
    co2 = co2 * 0.95 + (p['base_co2'] + visitor_boost) * 0.05

    return {
        'temperature': round(max(4.0,  min(16.0,  temp)),    2),
        'humidity':    round(max(60.0, min(100.0, humidity)), 1),
        'co2':         int(max(400,   min(2000,   round(co2)))),
    }


def fetch_sensors(conn) -> list[dict]:
    with conn.cursor() as cur:
        cur.execute("SELECT id, sensor_code FROM sensors ORDER BY sensor_code")
        return [{'id': row[0], 'code': row[1]} for row in cur.fetchall()]


def seed_history(conn, sensors: list[dict], days: int) -> None:
    now   = datetime.now(timezone.utc)
    start = now - timedelta(days=days)
    step  = timedelta(minutes=INTERVAL_MINUTES)
    total = int(days * 24 * 60 / INTERVAL_MINUTES)

    print(f"Seeding {total:,} readings × {len(sensors)} sensors "
          f"= {total * len(sensors):,} rows total…\n")

    for sensor in sensors:
        code = sensor['code']
        if code not in PROFILES:
            print(f"  {code}: no profile defined, skipping")
            continue

        print(f"  {code} … ", end='', flush=True)
        rows, prev, t = [], None, start
        while t <= now:
            r = generate_reading(code, t, prev)
            rows.append((t, sensor['id'], r['temperature'], r['humidity'], r['co2']))
            prev, t = r, t + step

        with conn.cursor() as cur:
            cur.executemany(
                "INSERT INTO cave_sensor_readings "
                "(measured_at, sensor_id, temperature, humidity, co2) "
                "VALUES (%s, %s, %s, %s, %s) ON CONFLICT DO NOTHING",
                rows,
            )
        conn.commit()
        print(f"{len(rows):,} rows inserted")


def live_mode(conn, sensors: list[dict], interval: int) -> None:
    print(f"\nLive mode — new reading every {interval}s  (Ctrl+C to stop)\n")
    prev_by: dict[str, dict] = {}

    while True:
        now = datetime.now(timezone.utc)
        with conn.cursor() as cur:
            for sensor in sensors:
                code = sensor['code']
                if code not in PROFILES:
                    continue
                r = generate_reading(code, now, prev_by.get(code))
                prev_by[code] = r
                cur.execute(
                    "INSERT INTO cave_sensor_readings "
                    "(measured_at, sensor_id, temperature, humidity, co2) "
                    "VALUES (%s, %s, %s, %s, %s)",
                    (now, sensor['id'], r['temperature'], r['humidity'], r['co2']),
                )
                print(f"  {code}  {now.strftime('%H:%M:%S')}  "
                      f"T={r['temperature']}°C  "
                      f"H={r['humidity']}%  "
                      f"CO2={r['co2']} ppm")
        conn.commit()
        time.sleep(interval)


def main() -> None:
    parser = argparse.ArgumentParser(description='Seed fake sensor data')
    parser.add_argument('--days',     type=int, default=30, help='Days of history (default: 30)')
    parser.add_argument('--clear',    action='store_true',  help='Truncate readings before seeding')
    parser.add_argument('--live',     action='store_true',  help='Stream live readings after history')
    parser.add_argument('--interval', type=int, default=10, help='Seconds between live readings (default: 10)')
    args = parser.parse_args()

    host = DB_URL.split('@')[1]
    print(f"Connecting to {host} …")

    with psycopg.connect(DB_URL) as conn:
        if args.clear:
            with conn.cursor() as cur:
                cur.execute("TRUNCATE cave_sensor_readings")
            conn.commit()
            print("Cleared existing readings.\n")

        sensors = fetch_sensors(conn)
        if not sensors:
            print("No sensors found. Run 04-sensors.sql init first.")
            return
        print(f"Sensors: {', '.join(s['code'] for s in sensors)}\n")

        if args.live:
            seed_history(conn, sensors, 1)   # prime with 24h so charts have data
            live_mode(conn, sensors, args.interval)
        else:
            seed_history(conn, sensors, args.days)
            print("\nDone.")


if __name__ == '__main__':
    main()
