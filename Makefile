.PHONY: setup test build

setup: 
	python3 -m venv .venv 
	pip install -r dev-requirements.txt

test: 
	PYTHONPATH=. .venv/lib/pytest -q

build: 
	docker build -t octabyte-api:local .

