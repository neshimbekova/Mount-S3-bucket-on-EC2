#!/bin/bash
#This script works on AWS on Centos 7
#This script installs Apache and mounts your existing amazon s3 bucket to ec2 instance

#Installing Apache, starting and making it boot persistant
yum install httpd -y
systemctl start httpd
systemctl enable httpd 

#Install the s3fs
yum install epel-release -y
yum install s3fs-fuse -y

#create a directory and mount S3bucket in it.
read -p "Enter your s3 bucket name :" bucket
read -p "Enter your IAM role name :" iamrole
s3fs $bucket /var/www/html/images -o iam_role=$iamrole
s3fs -o allow_other,iam_role=$iamrole,nonempty,uid=48,gid=48,umask=777,use_cache=/root/cache $bucket /var/www/html/images
