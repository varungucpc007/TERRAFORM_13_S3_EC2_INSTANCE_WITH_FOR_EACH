# -----------------------------
# AMI DATA SOURCES
# -----------------------------

data "aws_ami" "ubuntu_2204" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "aws_ami" "ubuntu_2404" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-noble-24.04-amd64-server-*"]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# -----------------------------
# LOCAL MAP (for_each)
# -----------------------------
locals {
  instances = {
    ubuntu_2204 = {
      ami       = data.aws_ami.ubuntu_2204.id
      disk_size = var.disk_sizes["ubuntu_2204"]
      name      = "Ubuntu-22.04"
    }

    ubuntu_2404 = {
      ami       = data.aws_ami.ubuntu_2404.id
      disk_size = var.disk_sizes["ubuntu_2404"]
      name      = "Ubuntu-24.04"
    }

    amazonlinux = {
      ami       = data.aws_ami.amazon_linux.id
      disk_size = var.disk_sizes["amazonlinux"]
      name      = "Amazon-Linux-2023"
    }
  }
}

# -----------------------------
# SECURITY GROUP
# -----------------------------
resource "aws_security_group" "ssh" {
  name   = "ssh-only-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# -----------------------------
# EC2 INSTANCES
# -----------------------------
resource "aws_instance" "ec2" {
  for_each = local.instances

  ami                    = each.value.ami
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.ssh.id]

  root_block_device {
    volume_size = each.value.disk_size
    volume_type = "gp3"
  }

  tags = merge(
    var.tags,
    {
      Name = each.value.name
    }
  )
}
