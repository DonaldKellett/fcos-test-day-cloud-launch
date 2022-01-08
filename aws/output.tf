output "fcos_public_ip" {
  description = "Public IP of our FCOS instance"
  value = aws_instance.fcos.public_ip
}
