# FastAPI + Kubernetes sample files

Included files:
- `Dockerfile`
- `.dockerignore`
- `k8s/app.yaml`

## What to do next


1. Make sure `requirements.txt` exists in your project root
2. Build the image locally:
   `docker build -t fastapi-pg-jsonb-demo:latest .`
3. Push it to a registry and replace the image name in `k8s/app.yaml`
4. Apply Kubernetes manifests:
   `kubectl apply -f k8s/app.yaml`

## Important note

This sample assumes PostgreSQL is reachable by the hostname `postgres`
from inside the Kubernetes cluster. In a real setup, that would usually be:
- a Kubernetes Service named `postgres`, or
- an external managed PostgreSQL host
