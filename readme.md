## readme

docker:

`docker compose up -d`

restart docker with deleting local volumes:
```
docker compose down -v
docker compose up -d
```

run:\
`uvicorn app.main:app --reload`

Expected local address:\
`http://127.0.0.1:8000`

swagger:\
`http://127.0.0.1:8000/docs`

adminer:\
`http://127.0.postg0.1:8080`

keycloak:\
`http://127.0.0.1:8081`

keycloak admin console:\
`http://127.0.0.1:8081/admin` (admin / admin)

filter examples:\
```
/events/filter?kind=cave
/events/filter?min_length=1000
/events/filter?kind=cave&region=Slovakia&min_length=1000
/events/filter?protected=true&max_length=2000
```

