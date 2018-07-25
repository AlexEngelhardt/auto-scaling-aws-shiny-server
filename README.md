# auto-scaling-aws-shiny-server

Recipe and scripts for hosting an elastic, auto-scaling Shiny server on Amazon AWS

### Blog post

- The details of how to use this code are described on my blog:
  - http://alpha-epsilon.de/r/2018/07/22/an-auto-scaling-shiny-server-on-aws/

### TODOs

- Version control the server infrastructure
  - Maybe create the VPC, EC2 instance, etc. via the AWS CLI instead of the
	console. That way, you can version control the infrastructure
    - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html#user-data-api-cli
  - Use a CloudFormation template
- Use a Docker container instead 
- Add Google Analytics (and eight popups about privacy stuff)
