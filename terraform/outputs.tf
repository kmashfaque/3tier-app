output "web_public_ip" {
  description = "Public IP address of the Nginx web server."
  value       = aws_instance.web.public_ip
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion host."
  value       = aws_instance.bastion.public_ip
}

output "app_private_ip" {
  description = "Private IP address of the application server."
  value       = aws_instance.app.private_ip
}

output "db_endpoint" {
  description = "RDS MySQL endpoint for the database tier."
  value       = aws_db_instance.appdb.address
}

output "db_port" {
  description = "RDS MySQL database port."
  value       = aws_db_instance.appdb.port
}

output "ssh_key_name" {
  description = "SSH key pair name created in AWS."
  value       = aws_key_pair.ssh.key_name
}
