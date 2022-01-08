resource "aws_instance" "fcos" {
  ami = var.fcos_ami
  instance_type = var.fcos_instance_type
  vpc_security_group_ids = [aws_security_group.fcos.id]
  user_data = file("../fcos-test-day.ign")
}
