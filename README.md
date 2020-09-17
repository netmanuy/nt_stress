# Load testing using AWS ECS Fargate
This is an small POC on how to execute Locust on ECS Fargate task, you can execute as many tasks as you want but keep in mind that tasks do not communicate with each other.

## On this Page
- [Architecture Overview](#architecture-overview)
- [Local testing](#local-testing)
- [Build & Deployment](#build-and-deployment)

## Architecture Overview
![Architecture](comming soon)

## Local testing
If you want to modify and test the load testing locally is super simple

```
docker-compose build
docker-compose up
```

To launch your test just open a browser and type ***http://localhost:8089***
If you want to run the tests using Taurus instead of Locust you need to modify ***load-test.sh*** comment line 10 and uncomment line 14


```
# Running the test using Locust
#locust -f bzt-configs/locustfile.py

# Running the test using Taurus
bzt nt_stress_taurus.yml -o modules.console.disable=true
```

## Build and Deployment

### Prerequisites:
* [AWS Command Line Interface](https://aws.amazon.com/cli/)
* [Docker](https://docs.docker.com/get-docker/)

### 1. Prepare your test
You can customize your load test modifying locustfile.py inside the **bzt-configs**

### 2. Upload your test to S3
We need to upload the test on a S3 bucket, if the bucket not exist the **load-test.sh** will try to create for you.

```
chmod +x ./build-s3-dist.sh
./build-s3-dist.sh <my bucket>
```

### 3. Launch the CloudFormation template.
Deploy the AWS CloudFormation stack using AWS Console 

### 4. Run ECS task with your test
Once the stack is deployed and the Codepipeline resource complete the build, you will be able to execute the Fargate task with your load testing example, in order to be avialbe to launch the Fargate task you need to know two importants resources created on this cloudformation stack

* Subnet Id
* Security group Id

```
aws ecs run-task --cluster STACK_NAME --task-definition  STACK_NAME:1 --count 1 --network-configuration '{"awsvpcConfiguration":{"subnets":["SUBNET_ID"],"securityGroups":["SECURITY_GROUP_ID"],"assignPublicIp":"ENABLED"}}' --launch-type FARGATE
```

### 5. Load Locust admin, this step is only needed if you chose to use Locust instead of Taurus
Just open a browser and type ***http://task_ip:8089***
