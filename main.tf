module "labels" {
  source  = "clouddrove/labels/aws"
  version = "1.3.0"

  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  repository  = var.repository
}

module "s3_bucket" {
  source = "clouddrove/s3/aws"

  name                          = var.name
  environment                   = var.environment
  attributes                    = ["private"]
  label_order                   = var.label_order
  versioning                    = true
  acceleration_status           = true
  request_payer                 = true
  logging                       = false
  enable_server_side_encryption = false
  enable_kms                    = false
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
      flow_logs_s3_bucket = module.s3_bucket.bucket
      flow_logs_s3_prefix = var.flow_logs_s3_prefix
    }
  }
}

resource "aws_globalaccelerator_listener" "example" {
  for_each = { for i, listener in var.listeners : format("listener-%v", i) => listener }

  accelerator_arn = aws_globalaccelerator_accelerator.example[0].id
  client_affinity = lookup(each.value.client_affinity, null)
  protocol        = lookup(each.value.protocol, "TCP")

  dynamic "port_range" {
    for_each = lookup(each.value.port_ranges, [{
      from_port = lookup(port_range.value, "from_port", null)
      to_port   = lookup(port_range.value, "to_port", null)
    }])
  }
  content {
    from_port = lookup(port_range.value.from_port, null)
    to_port   = lookup(port_range.value.to_port, null)
  }
}

resource "aws_globalaccelerator_endpoint_group" "example" {
  for_each = { for key, val in var.listeners : key => val if var.create_resources && var.create_listeners && length(lookup(var.listeners[k], "endpoint_group", {})) >= 0 }

  listener_arn                  = aws_globalaccelerator_listener.example[each.key].id
  endpoint_group_region         = try(each.value.endpoint_group.endpoint_group_region, null)
  health_check_interval_seconds = try(each.value.endpoint_group.health_check_interval_seconds, null)
  health_check_port             = try(each.value.endpoint_group.health_check_port, null)
  health_check_protocol         = try(each.value.endpoint_group.health_check_protocol, null)
  threshold_count               = try(each.value.endpoint_group.threshold_count, null)
  traffic_dial_percentage       = try(each.value.endpoint_group.traffic_dial_percentage, null)

  dynamic "endpoint_config" {
    for_each = [for e in try(each.value.endpoint_group.endpoint_config, []) : e if can(e.endpoint_id)]
    content {
      client_ip_preservation_enabled = try(endpoint_config.value.client_ip_preservation_enabled, null)
      endpoint_id                    = endpoint_config.value.endpoint_id
      weight                         = try(endpoint_config.value.weight, null)
    }
  }
}

