packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "ami_name_prefix" {
  type    = string
  default = "nginx-webserver"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ssh_username" {
  type    = string
  default = "ec2-user"
}

# Data source to get the latest Amazon Linux 2023 AMI
data "amazon-ami" "amazon_linux_2023" {
  filters = {
    name                = "al2023-ami-*-x86_64"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["amazon"]
  region      = var.aws_region
}

source "amazon-ebs" "nginx" {
  ami_name      = "${var.ami_name_prefix}-{{timestamp}}"
  instance_type = var.instance_type
  region        = var.aws_region
  source_ami    = data.amazon-ami.amazon_linux_2023.id
  ssh_username  = var.ssh_username

  tags = {
    Name        = "${var.ami_name_prefix}-{{timestamp}}"
    Environment = "production"
    OS          = "Amazon Linux 2023"
    BuildDate   = "{{timestamp}}"
    ManagedBy   = "Packer"
  }

  launch_block_device_mappings {
    device_name = "/dev/xvda"
    volume_size = 30
    volume_type = "gp3"
    delete_on_termination = true
  }
}

build {
  name = "nginx-ami"
  sources = [
    "source.amazon-ebs.nginx"
  ]

  # Pack phase - Install and configure nginx
  provisioner "ansible" {
    playbook_file = "${path.root}/ansible/pack-playbook.yml"
    user          = var.ssh_username
    use_proxy     = false
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_SSH_ARGS=-o ControlMaster=auto -o ControlPersist=60s -o UserKnownHostsFile=/dev/null",
      "ANSIBLE_PIPELINING=True"
    ]
    extra_arguments = [
      "--extra-vars",
      "ansible_python_interpreter=/usr/bin/python3",
      "--scp-extra-args", "'-O'"
    ]
  }

  # Fry phase - Prepare for runtime configuration
  provisioner "ansible" {
    playbook_file = "${path.root}/ansible/fry-playbook.yml"
    user          = var.ssh_username
    use_proxy     = false
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_SSH_ARGS=-o ControlMaster=auto -o ControlPersist=60s -o UserKnownHostsFile=/dev/null",
      "ANSIBLE_PIPELINING=True"
    ]
    extra_arguments = [
      "--extra-vars",
      "ansible_python_interpreter=/usr/bin/python3",
      "--scp-extra-args", "'-O'"
    ]
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}
