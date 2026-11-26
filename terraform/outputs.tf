output "app_public_ip" {
  value = aws_instance.app.public_ip
}

output "app_private_ip" {
  value = aws_instance.app.private_ip
}

output "database_private_ip" {
  value = aws_instance.database.private_ip
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "mongodb_volume_id" {
  value = aws_ebs_volume.mongodb.id
}
