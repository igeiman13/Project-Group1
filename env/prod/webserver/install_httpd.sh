#!/bin/bash
yum -y update
yum -y install httpd
echo '<h1><center>Group 1 ! Group members: Minnu Thomas, Praveen Suresh, Neethu Dominic, Tejaswi Sindhuri</center></h1>
 <img src="https://finalproject-websitefiles.s3.us-east-1.amazonaws.com/tulip.jpeg"> <img src="https://finalproject-websitefiles.s3.us-east-1.amazonaws.com/hibiscus.jpeg">'   >  /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
