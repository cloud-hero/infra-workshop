# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_elb" "consul-docker-master-elb" {
  name = "consul-docker-master"

  # The same availability zone as our instances
  #availability_zones = ["${split(",", var.availability_zones)}"]
  security_groups = ["${split(",", var.aws_security_group_elb)}"]
  subnets = ["${split(",", var.subnets)}"]
  internal = true

  listener {
    instance_port     = 4000
    instance_protocol = "tcp"
    lb_port           = 4000
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 8500
    instance_protocol = "tcp"
    lb_port           = 8500
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:4000"
    interval            = 10
  }
}

resource "aws_autoscaling_group" "consul-docker-master-asg" {
  vpc_zone_identifier  = ["${split(",", var.subnets)}"]
  name                 = "consul-docker-master-asg"
  max_size             = "${var.asg_max}"
  min_size             = "${var.asg_min}"
  desired_capacity     = "${var.asg_desired}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.consul-docker-master-lc.name}"
  load_balancers       = ["${aws_elb.consul-docker-master-elb.name}"]

  tag {
    key                 = "Name"
    value               = "consul-docker-master-asg"
    propagate_at_launch = "true"
  }

    tag {
    key                 = "consul"
    value               = "true"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "consul-docker-master-lc" {
  name          = "consul-docker-master-lc"
  image_id      = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.instance_type_consul-docker-master}"
  root_block_device {
    #device_name           = "/dev/sda1"
    volume_type           = "gp2"
    volume_size           = 10
    delete_on_termination = true
  }

  # Security group
  security_groups = ["${var.aws_security_group_ec2}"]
  user_data       = "${file("userdata-consul-docker-master.sh")}"
  key_name        = "${var.key_name}"
}