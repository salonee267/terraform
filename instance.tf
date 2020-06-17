provider "aws" {
			region = "us-east-1"
}

#creating Security Group allow ssh & http

resource "aws_security_group" "hello-terra-security-group" {
			name = "hello-terra"
			description = "allow ssh & http trafic"
			
			
			ingress {
					from_port = 22
					to_port = 22
					protocol = "tcp"
					cidr_blocks = ["0.0.0.0/0"]
			
			}
			
			ingress {
					from_port = 80
					to_port = 80
					protocol = "tcp"
					cidr_blocks = ["0.0.0.0/0"]
			
			}
			
			egress {
					from_port = 0
					to_port = 0
					protocol = "-1"
					cidr_blocks = ["0.0.0.0/0"]
			
			}
}
#security group ends here

#creating an inatance
resource "aws_instance" "hello-terra" {
			ami = "ami-01d025118d8e760db"
			instance_type = "t2.micro"
			availability_zone = "us-east-1a"
			security_groups = ["${aws_security_group.hello-terra-security-group.name}"]
			key_name = "22Aprilkey" 
			user_data = <<-EOF
					  #! /bin/bash
					  sudo yum install httpd -y
					  sudo service httpd start
					  chkconfig httpd on
					  ipaddr=$(host myip.opendns.com resolver1.opendns.com| grep 'has address' | cut -d ' ' -f4)
					  echo "<h1>Hello from $ipaddr</h1>" >> /var/www/html/index.html
			EOF
					  
			tags ={
					Name = "Webserver"
			}
}
#instance code ends here

#Assigning EIP to our Instance
resource "aws_eip" "hello-terra-eip"{
		instance = "${aws_instance.hello-terra.id}"	
		tags = {
				name = "hello-terra-eip"
		}
}
#EIP code ends here