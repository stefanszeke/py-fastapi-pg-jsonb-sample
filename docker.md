## Docker

Start local services:

```bash
docker compose up -d
```

Stop local services:

```bash
docker compose down
```

Restart and delete local database data:

```bash
docker compose down -v
docker compose up -d
```

Check containers:

```bash
docker ps
```

---

## Rancher Desktop / nerdctl

Start local services:

```bash
nerdctl compose -f compose.nerdctl.yml up -d
```

Stop local services:

```bash
nerdctl compose -f compose.nerdctl.yml down
```

Restart and delete local database data:

```bash
nerdctl compose -f compose.nerdctl.yml down -v
nerdctl compose -f compose.nerdctl.yml up -d
```

Check containers:

```bash
nerdctl ps
```

---
