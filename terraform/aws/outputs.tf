output "aws_vm_ip" {
  value = aws_instance.bankpro_aws_vm.public_ip
}
