output "instance_ids" {
  value = {
    for k, v in aws_instance.ec2 : k => v.id
  }
}

output "public_ips" {
  value = {
    for k, v in aws_instance.ec2 : k => v.public_ip
  }
}

output "private_ips" {
  value = {
    for k, v in aws_instance.ec2 : k => v.private_ip
  }
}
