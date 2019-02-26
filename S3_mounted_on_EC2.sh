#!/bin/bash
#This script works on AWS on Amazon Linux 2 AMI
#This script installs Apache and mountss your existing 'ec2' to 's3'bucket

#Installing Apache, starting and making it boot persistant
yum install httpd -y
systemctl start httpd
systemctl enable httpdg 

#Install the dependencies
yum -y install automake fuse fuse-devel gcc-c++ git libcurl-devel libxml2-devel make openssl-devel -y
#Clone s3fs source code from github
git clone https://github.com/s3fs-fuse/s3fs-fuse.git
#Next 4 lines will change to source code  directory, compile and install the code 
cd s3fs-fuse/
./autogen.sh && ./configure
make
make install

#create a directory and mount S3bucket in it.
read -p "Enter your folder name :" folder
mkdir -p /var/www/html/$folder
read -p "Enter your s3 bucket name :" bucket
read -p "Enter your IAM role name :" iamrole
s3fs $bucket /var/www/html/$folder -o iam_role=$iamrole
s3fs -o allow_other,iam_role=$iamrole,nonempty,uid=48,gid=48,umask=777,use_cache=/root/cache $bucket /var/www/html/$folder
