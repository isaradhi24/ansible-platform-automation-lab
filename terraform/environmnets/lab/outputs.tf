output "ansible_controller_public_ip" {
  description = "Public IP address of the Ansible controller"
  value       = aws_instance.ansible_controller.public_ip
}

output "ansible_controller_private_ip" {
  description = "Private IP of the Ansible controller"
  value       = aws_instance.ansible_controller.private_ip
}

output "ubuntu_node_private_ip" {
  description = "Private IP of Ubuntu managed node"
  value       = aws_instance.ubuntu_node.private_ip
}

output "ubuntu_node_public_ip" {
  description = "Public IP of Ubuntu managed node"
  value       = aws_instance.ubuntu_node.public_ip
}