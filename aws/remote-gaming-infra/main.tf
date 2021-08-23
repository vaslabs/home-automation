resource "aws_launch_template" "gamepads_launch_template" {
  name = "gamepads"

  credit_specification {
    cpu_credits = "standard"
  }

  image_id = "ami-0d9b1a21d409a17ee"

  iam_instance_profile {
      name = aws_iam_instance_profile.gamepad_instance_profile.name
  }

  update_default_version = true

  instance_initiated_shutdown_behavior = "stop"

  instance_type = "t2.micro"
  monitoring {
    enabled = false
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination = true
  }

  placement {
    availability_zone = "eu-west-1a"
  }


  tags = {
    purpose = "gamepads"
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
        purpose = "gamepads"
    }
  }

  user_data = filebase64("setup_ds4drv.sh")
}


resource "aws_vpc" "internet_relay_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    purpose = "remote-gaming"
  }
}

resource "aws_security_group" "allow_ssh_traffic" {
  name        = "allow_ssh"
  description = "Allow SSH inbound/outbound traffic"
  vpc_id      = aws_vpc.internet_relay_vpc.id

  ingress = [
    {
      description      = "SSH from the internet"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null
      security_groups = null
      self = null
    }
  ]

  egress = [
    {
      description = "SSH to the internet"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null
      security_groups = null
      self = null
    }
  ]

  tags = {
    Name = "allow_ssh"
    purpose = "gaming"
  }
}

resource "aws_iam_instance_profile" "gamepad_instance_profile" {
  name = "gamepad_instance_profile"
  role = aws_iam_role.gamepad_instance_role.name
}

resource "aws_iam_role" "gamepad_instance_role" {
  name = "gamepad_instance_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}