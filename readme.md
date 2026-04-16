## readme

run:\
`uvicorn main:app --reload`


Expected local address:\
`http://127.0.0.1:8000`


swagger:\
`http://127.0.0.1:8000/docs`

filter examples:\
```
/events/filter?kind=cave
/events/filter?min_length=1000
/events/filter?kind=cave&region=Slovakia&min_length=1000
/events/filter?protected=true&max_length=2000
```