output "launch_configuration_node" {
  value = "${aws_launch_configuration.computaris-node-lc.id}"
}

output "asg_name_node" {
  value = "${aws_autoscaling_group.computaris-node-asg.id}"
}