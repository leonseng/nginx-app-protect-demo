output "nplus_public_ip" {
  value       = aws_eip.nplus_eip.public_ip
  description = "The public IP address of the NGINX Plus server"
}
