output "id" {
  value       = module.global_accelerator.id
  description = "The Amazon Resource Name (ARN) of the accelerator"
}

output "dns_name" {
  value       = module.global_accelerator.dns_name
  description = "The DNS name of the accelerator"
}

output "listeners" {
  value       = module.global_accelerator.listeners
  description = "Map of listeners created and their associated attributes"
}

output "endpoint_groups" {
  value       = module.global_accelerator.endpoint_groups
  description = "Map of endpoints created and their associated attributes"
}