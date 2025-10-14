Steps for implementation:
1.  Deploy a VPC and a subnet.
2.  Deploy an internet gateway and associate it with the VPC.
3.  Setup a route table with a route to the IGW.
4.  Deploy an EC2 instance inside of the created subnet.
5.  Associate a public IP and a security group that allows public ingress.
6.  Change the EC2 instance to use a publicly available NGINX AMI.
7.  Destory everything.