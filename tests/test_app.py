from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"


def test_root():
    response = client.get("/")
    assert response.status_code == 200
    assert "message" in response.json()


def test_metrics_use_bounded_label_for_unmatched_paths():
    client.get("/does-not-exist/1")
    client.get("/does-not-exist/2")

    response = client.get("/metrics")

    assert response.status_code == 200
    assert 'http_request_total{method="GET",path="unmatched",status="404"} 2.0' in response.text
    assert 'path="/does-not-exist/1"' not in response.text
    assert 'path="/does-not-exist/2"' not in response.text


def test_metrics_record_unhandled_errors():
    def fail():
        raise RuntimeError("test error")

    app.add_api_route("/_test/error", fail)
    error_client = TestClient(app, raise_server_exceptions=False)

    response = error_client.get("/_test/error")
    metrics = client.get("/metrics")

    assert response.status_code == 500
    assert 'http_request_total{method="GET",path="/_test/error",status="500"} 1.0' in metrics.text
