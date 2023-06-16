provider "aws" {
  region = "us-west-2"
}

module "s3_bucket" {
  source      = "clouddrove/s3/aws"
  version     = "1.3.0"
  name        = "clouddrove-ga-bucket"
  environment = "test"
  label_order = ["name", "environment"]
  versioning  = true
  acl         = "private"
}

module "global_accelerator" {
  source = "../../"

  name        = "example"
  environment = "test"
  label_order = ["name", "environment"]

  flow_logs_enabled   = true
  flow_logs_s3_bucket = module.s3_bucket.id
  flow_logs_s3_prefix = "example"

  listeners = {
    listener_1 = {
      client_affinity = "SOURCE_IP"
      
      endpoint_group = {
        health_check_port             = 80
        health_check_protocol         = "HTTP"
        health_check_path             = "/"
        health_check_interval_seconds = 10
        health_check_timeout_seconds  = 5
        healthy_threshold_count       = 2
        unhealthy_threshold_count     = 2
        traffic_dial_percentage       = 100

        endpoint_configuration = [{
          client_ip_preservation_enabled = true
          endpoint_id                    = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/blue/1234567890123456"
          weight                         = 50
          }, {
          client_ip_preservation_enabled = false
          endpoint_id                    = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/green/1234567890123456"
          weight                         = 50
        }]
      }

      port_ranges = [
        {
          from_port = 80
          to_port   = 80
        },
      ]
      protocol = "TCP"
    }
  }
}