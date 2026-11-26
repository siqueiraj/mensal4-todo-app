resource "aws_key_pair" "main" {
  key_name   = "mensal4-key"
  public_key = file(pathexpand("~/.ssh/mensal4.pub"))
}
