####----------------------------------------------------------------------------------
## Provider block added, Use the Amazon Web Services (AWS) provider to interact with the many resources supported by AWS.
####----------------------------------------------------------------------------------
provider "aws" {
  region = "us-west-2"
}

####----------------------------------------------------------------------------------
## Amazon Simple Storage Service (Amazon S3) is an object storage service that offers industry-leading scalability, data availability, security, and performance
####----------------------------------------------------------------------------------
module "s3_bucket" {
  source      = "clouddrove/s3/aws"
  version     = "2.0.0"
  name        = "clouddrove-ga-bucket"
  environment = "test"
  label_order = ["name", "environment"]
  versioning  = true
  acl         = "private"
}

####----------------------------------------------------------------------------------
## global_accelerator model has been added.
####----------------------------------------------------------------------------------
module "global_accelerator" {
  source = ".././"

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
        endpoint_group_region          = "eu-west-1"
        multiple_endpoint_group_region = "us-west-2"
        health_check_port              = 80
        health_check_protocol          = "HTTP"
        health_check_path              = "/"
        health_check_interval_seconds  = 10
        health_check_timeout_seconds   = 5
        healthy_threshold_count        = 2
        unhealthy_threshold_count      = 2
        traffic_dial_percentage        = 100

        endpoint_configuration = [
          {
            client_ip_preservation_enabled = true
            endpoint_id                    = "arn:aws:elasticloadbalancing:eu-west-1:924144197303:loadbalancer/app/alb-test/0f88bb12974358d8"
            weight                         = 50
          }
        ],
        multiple_endpoint_configuration = [
          {
            client_ip_preservation_enabled = true
            endpoint_id                    = "arn:aws:elasticloadbalancing:us-west-2:924144197303:loadbalancer/app/alb-test/9f4c48e341384ddd"
            weight                         = 50
          }
        ]
      }

      port_ranges = [
        {
          from_port = 80
          to_port   = 80
        }
      ]
      protocol = "TCP"
    }
  }
}
