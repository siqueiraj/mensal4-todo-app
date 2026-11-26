resource "aws_ebs_volume" "mongodb" {
  availability_zone = aws_subnet.private.availability_zone
  size              = 10
  type              = "gp3"
  encrypted         = true

  tags = {
    Name = "mensal4-mongodb-data"
  }
}

resource "aws_volume_attachment" "mongodb" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.mongodb.id
  instance_id = aws_instance.database.id
}
