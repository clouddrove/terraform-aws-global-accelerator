output "id" {
  value       = try(aws_globalaccelerator_accelerator.example[0].id, "")
  description = "The ARN of the accelerator"
}

output "dns_name" {
  value       = try(aws_globalaccelerator_accelerator.example[0].dns_name, "")
  description = "DNS name of the accelerator"
}

output "listeners" {
  value       = aws_globalaccelerator_listener.example
  description = "Map of listeners created and their specified attributes"
}

output "endpoint_groups" {
  value       = aws_globalaccelerator_endpoint_group.example
  description = "Map of endpoints created and their specified attributes"
}