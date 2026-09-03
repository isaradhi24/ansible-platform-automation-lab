resource "aws_vpc" "lab" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ansible-lab-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.lab.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "ansible-lab-public-subnet"
  }
}

resource "aws_internet_gateway" "lab" {
  vpc_id = aws_vpc.lab.id

  tags = {
    Name = "ansible-lab-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.lab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab.id
  }

  tags = {
    Name = "ansible-lab-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

########### Security Group for EC2 Instances ###########
resource "aws_security_group" "lab_ssh" {
  name        = "ansible-lab-ssh"
  description = "Allows SSH access to ansible-lab instances"
  vpc_id      = aws_vpc.lab.id

  ### SSH from Desktop #####
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  ### SSH between instances that use this same SG #####
  ingress {
    description = "Allow SSH between instances in the same security group"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    self        = true
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ansible-lab-ssh-sg"
  }
}

############ AMI LOOKUP ############

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

########### EC2 Instance ###########
resource "aws_instance" "ansible_controller" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.lab_ssh.id]

  associate_public_ip_address = true

  key_name = aws_key_pair.ansible_lab.key_name

  user_data = <<-EOF
              #!/bin/bash
              echo "preserve_hostname: true" > /etc/cloud/cloud.cfg.d/99-preserve-hostname.cfg
              hostnamectl set-hostname ansible-controller

              apt-get update -y
              DEBIAN_FRONTEND=noninteractive apt-get install -y \
                python3 \
                python3-pip \
                ansible \
                git
              EOF

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name     = "ansible-controller"
    role     = "ansible-controller"
    OSFamily = "ubuntu"
  }
}

resource "aws_key_pair" "ansible_lab" {
  key_name   = "ansible-lab-key"
  public_key = file(pathexpand(var.public_key_path))

  tags = {
    Name = "ansible-lab-key"
  }
}

########## ansible managed instances ##########  

##########  Ubuntu 24.04 LTS  ##########
resource "aws_instance" "ubuntu_node" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.lab_ssh.id]

  associate_public_ip_address = true

  key_name = aws_key_pair.ansible_lab.key_name

  user_data = <<-EOF
              #!/bin/bash
              echo "preserve_hostname: true" > /etc/cloud/cloud.cfg.d/99-preserve-hostname.cfg
              hostnamectl set-hostname ubuntu-node
              apt update -y
              apt install -y python3 python3-pip
              EOF

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name     = "managed-ubuntu-node"
    role     = "managed-node"
    OSFamily = "ubuntu"
  }
}
