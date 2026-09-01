import os
import time 
import logging

from fastapi import FastAPI, Response
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST

logging.basicConfig(level=os.getenv("LOG_LEVEL", "INFO"), format="%(asctime)s %(levelname)s %(message)s")
logger = logging.getLogger(__name__)
app = FastAPI(title="OctaByte", version="1.0.0")
REQUESTS = Counter("http_request_total", "HTTP requests", ['method', 'path', 'status'])
LATENCY = Histogram("http_request_duration_seconds", "Request Latency", ["method", "path"])

@app.middleware("http")
async def metric_middleware(request, next_call):
    start = time.perf_counter()
    status_code = 500
    try:
        response = await next_call(request)
        status_code = response.status_code
        return response
    finally:
        route = request.scope.get("route")
        path = getattr(route, "path", "unmatched")
        REQUESTS.labels(request.method, path, status_code).inc()
        LATENCY.labels(request.method, path).observe(time.perf_counter() - start)
        logger.info("request method=%s path=%s status=%s", request.method, path, status_code)

@app.get("/")
def root():
    return {"message": "Octabyte Assessment", "version":"1.0.0"}


@app.get("/health")
def health():
    return {"status": "ok", "environment": os.getenv("ENVIRONMENT", "local")}


@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)

