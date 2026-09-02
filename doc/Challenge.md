# Challenges and Fixes

## ALB returned 503 service unavailable

Problem : The load balancer endpoint prepared and given was giving 503 service unavailable. After the deployment(Apply plan)

ECS had been set the desired_count = 0 where the ECR repo was empty and the target groups were not able to get any registeres targets for the same so built and pushed the local application image to teh ECR then check the staging setup to run a single ECS task. Target health was then checked upon deployment.

## Slack did not notify and report the ALB failure of the above reason. 

Problem : There was no notification of any kind(slack) when the ALB returned 503 error after the deployment when started. 

The initial setup was made for the webhook to use only the certain metrics and alerts like GitHub Action, where as Cloudwatch alarms do not have any kind of trigger until manual intervention was made, this was later documented and got it confirmed that the cloudwatch alarms require a slack runtime to be sent to SNS and AWS chatbot or a lambda function using webhook-forwarding. 


## Current state

- Local tests pass
- Docker image build and runs as a non-root user.
- Prometheus successfully scrapes the necessercy metrics for API.
- AWS staging and prod infrastructure has been planned accordingly and created.
- The first image has been pushed to the ECR.
- CLoudWatch give the necessary dashboard and status and alarms as per the availibility of the services. 




