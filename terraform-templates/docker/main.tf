# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_elb" "jenkins-elb-public" {
  name = "jenkins"

  # The same availability zone as our instances
  #availability_zones = ["${split(",", var.availability_zones)}"]
  security_groups = ["${split(",", var.aws_security_group_elb_jenkins)}"]
  subnets = ["${split(",", var.subnets)}"]
  internal = false

  listener {
    instance_port     = 8080
    instance_protocol = "tcp"
    lb_port           = 8080
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8080"
    interval            = 10
  }
}

resource "aws_autoscaling_group" "docker-node-asg" {
  vpc_zone_identifier  = ["${split(",", var.subnets)}"]
  name                 = "docker-node-asg"
  max_size             = "${var.asg_max}"
  min_size             = "${var.asg_min}"
  desired_capacity     = "${var.asg_desired}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.docker-node-lc.name}"
  load_balancers       = ["${aws_elb.jenkins-elb-public.name}"]

  tag {
    key                 = "Name"
    value               = "docker-node-asg"
    propagate_at_launch = "true"
  }

    tag {
    key                 = "consul"
    value               = "true"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "docker-node-lc" {
  name          = "docker-node-lc"
  image_id      = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.instance_type_node}"
  root_block_device {
    #device_name           = "/dev/sda1"
    volume_type           = "gp2"
    volume_size           = 50
    delete_on_termination = true
  }

  # Security group
  security_groups = ["${var.aws_security_group_ec2}"]
  user_data       = "${file("userdata-node.sh")}"
  key_name        = "${var.key_name}"
}