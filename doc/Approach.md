# Approach

## Main Objective

Building a small and complete DevOps Delivery path for a FastAPI application, covering the local development, containers, AWS infra, secrets, monitoring & deployment foundations. The logic is intentionally kept simple because the main goal to demonstrate infrastructure and ownership. 

## Containerization

- Used FastAPI with "/", "/health", "/metrics" endpoints.
- Added a request-count and latency metrics using prometheus-client
- Used routing template and metric labels to prevent any kind of cardinality
- Added endpoints and failure-path tests using test scripts. 
- Created non-root Docker image with standard-library health check.
- Uses Docker compose for local API, Prometheus & Grafana testing. 

## AWS Architecture

- A VPC across two availablility zones.
- Two public subnets for ALB and NAT Gateways>
- Two private subnets for ECS tasks.
- Two database subnet for PostgreSQL and RDS
- ECS behind an ALB
- ECR for immutable application images
- Cloudwatch alarm, logs & dashboards
- Private, encrypted RDS postgreSQL

## Security state management

- A configuration creates tghe terraform state bucket. 
- S3 bucket uses encryption, versioning, public-access block, state locking.
- Provider based lock files are committed for reproducible initializations. 
- Staging, Production uses different state keys alsong with variable files. 

## Deployment Approach

1. Run tests and build a Docker image. 
2. Provisioning stating infra with zero ECS tasks. 
3. Push an immutable GIT-SHA image to ECR
4. Set the image tag and desired count to 1
5. Apply only the reviewed plan. 
6. verify the ECS tasks health, target health. 


## Monitoring 

- Prometheus and grafana to provide a local request rate, latency, availibility & error visibility.
- Cloudwatch for service and application log data on AWS. 
- Darshboards using cloudwatch to cover Databases. 
- Cloudwatch alarms for currently and any kind of CPU, ALB & 5XX conditions.


