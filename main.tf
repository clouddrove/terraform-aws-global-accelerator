module "labels" {
  source  = "clouddrove/labels/aws"
  version = "1.3.0"

  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  repository  = var.repository
}

resource "aws_globalaccelerator_accelerator" "example" {

  name            = module.labels.id
  enabled         = var.enabled
  ip_address_type = var.ip_address_type
  tags            = module.labels.tags

  dynamic "attributes" {
    for_each = var.flow_logs_enabled ? [1] : []
    content {
      flow_logs_enabled   = var.flow_logs_enabled
      flow_logs_s3_bucket = var.flow_logs_s3_bucket
      flow_logs_s3_prefix = var.flow_logs_s3_prefix
    }
  }
}

resource "aws_globalaccelerator_listener" "example" {
  for_each = { for key, val in var.listeners : key => val if var.create_resources && var.create_listeners }

  accelerator_arn = aws_globalaccelerator_accelerator.example.id
  client_affinity = lookup(each.value, "client_affinity", null)
  protocol        = lookup(each.value, "protocol", "TCP")

  dynamic "port_range" {
    for_each = try(each.value.port_ranges, [{
      from_port = 80
      to_port   = 80
    }])

    content {
      from_port = try(port_range.value.from_port, null)
      to_port   = try(port_range.value.to_port, null)
    }
  }
}

resource "aws_globalaccelerator_endpoint_group" "example" {
  for_each = { for key, val in var.listeners : key => val if var.create_resources && var.create_listeners && length(lookup(var.listeners[key], "endpoint_group", {})) > 0 }

  listener_arn                  = aws_globalaccelerator_listener.example[each.key].id
  endpoint_group_region         = try(each.value.endpoint_group.endpoint_group_region, null)
  health_check_interval_seconds = try(each.value.endpoint_group.health_check_interval_seconds, null)
  health_check_port             = try(each.value.endpoint_group.health_check_port, null)
  health_check_protocol         = try(each.value.endpoint_group.health_check_protocol, null)
  threshold_count               = try(each.value.endpoint_group.threshold_count, null)
  traffic_dial_percentage       = try(each.value.endpoint_group.traffic_dial_percentage, null)

  dynamic "endpoint_configuration" {
    for_each = [for e in try(each.value.endpoint_group.endpoint_configuration, []) : e if can(e.endpoint_id)]
    content {
      client_ip_preservation_enabled = try(endpoint_configuration.value.client_ip_preservation_enabled, null)
      endpoint_id                    = endpoint_configuration.value.endpoint_id
      weight                         = try(endpoint_configuration.value.weight, null)
    }
  }
}

