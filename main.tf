provider "aws" {
  region = "your_aws_region"  # Specify your AWS region
}

resource "aws_instance" "example" {
  ami           = "ami-0742b4e673072066f"  # CentOS 7 AMI ID, you might need to replace this with the latest AMI
  instance_type = "t2.micro"  # Instance type, can be modified as needed
  key_name      = "your_key_pair_name"  # Replace with your key pair name for SSH access

  tags = {
    Name = "example-instance"  # Name for your instance
  }

  # Security group configuration allowing SSH access (change the CIDR block as needed)
  security_groups = ["ssh-access"]

  # SSH key configuration for connecting to the instance
  key_name = "your_key_pair_name"  # Replace with your key pair name for SSH access

  # User data to perform provisioning actions like installing software on the instance
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y  # Update packages
              sudo yum install httpd -y  # Install Apache (example)
              sudo systemctl start httpd  # Start Apache
              sudo systemctl enable httpd  # Enable Apache to start on boot
              EOF
}

# Security group allowing inbound SSH access
resource "aws_security_group" "ssh-access" {
  name        = "ssh-access"
  description = "Allow SSH inbound traffic"
  vpc_id      = "your_vpc_id"  # Replace with your VPC ID

  # Inbound rule for SSH (port 22) from anywhere (you might want to restrict this to your IP)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your IP or restrict to specific IP ranges
  }
}
