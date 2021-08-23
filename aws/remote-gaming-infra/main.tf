resource "aws_launch_template" "gamepads_launch_template" {
  name = "gamepads"

  credit_specification {
    cpu_credits = "standard"
  }

  iam_instance_profile {
    name = "test"
  }

  image_id = "ami-0d9b1a21d409a17ee"

  instance_initiated_shutdown_behavior = "stop"

  instance_market_options {
    market_type = "spot"
  }

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