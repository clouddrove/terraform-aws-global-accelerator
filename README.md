<!-- This file was automatically generated by the `geine`. Make all changes to `README.yaml` and run `make readme` to rebuild this file. -->

<p align="center"> <img src="https://user-images.githubusercontent.com/50652676/62349836-882fef80-b51e-11e9-99e3-7b974309c7e3.png" width="100" height="100"></p>


<h1 align="center">
    Terraform AWS Global Accelerator
</h1>

<p align="center" style="font-size: 1.2rem;"> 
    Terraform module to create Global Accelerator resource on AWS.
     </p>

<p align="center">

<a href="https://github.com/clouddrove/terraform-aws-global-accelerator/releases/latest">
  <img src="https://img.shields.io/github/release/clouddrove/terraform-aws-global-accelerator.svg" alt="Latest Release">
</a>
<a href="https://github.com/clouddrove/terraform-aws-global-accelerator/actions/workflows/tfsec.yml">
  <img src="https://github.com/clouddrove/terraform-aws-global-accelerator/actions/workflows/tfsec.yml/badge.svg" alt="tfsec">
</a>
<a href="LICENSE.md">
  <img src="https://img.shields.io/badge/License-APACHE-blue.svg" alt="Licence">
</a>


</p>
<p align="center">

<a href='https://facebook.com/sharer/sharer.php?u=https://github.com/clouddrove/terraform-aws-global-accelerator'>
  <img title="Share on Facebook" src="https://user-images.githubusercontent.com/50652676/62817743-4f64cb80-bb59-11e9-90c7-b057252ded50.png" />
</a>
<a href='https://www.linkedin.com/shareArticle?mini=true&title=Terraform+AWS+Global+Accelerator&url=https://github.com/clouddrove/terraform-aws-global-accelerator'>
  <img title="Share on LinkedIn" src="https://user-images.githubusercontent.com/50652676/62817742-4e339e80-bb59-11e9-87b9-a1f68cae1049.png" />
</a>
<a href='https://twitter.com/intent/tweet/?text=Terraform+AWS+Global+Accelerator&url=https://github.com/clouddrove/terraform-aws-global-accelerator'>
  <img title="Share on Twitter" src="https://user-images.githubusercontent.com/50652676/62817740-4c69db00-bb59-11e9-8a79-3580fbbf6d5c.png" />
</a>

</p>
<hr>


We eat, drink, sleep and most importantly love **DevOps**. We are working towards strategies for standardizing architecture while ensuring security for the infrastructure. We are strong believer of the philosophy <b>Bigger problems are always solved by breaking them into smaller manageable problems</b>. Resonating with microservices architecture, it is considered best-practice to run database, cluster, storage in smaller <b>connected yet manageable pieces</b> within the infrastructure. 

This module is basically combination of [Terraform open source](https://www.terraform.io/) and includes automatation tests and examples. It also helps to create and improve your infrastructure with minimalistic code instead of maintaining the whole infrastructure code yourself.

We have [*fifty plus terraform modules*][terraform_modules]. A few of them are comepleted and are available for open source usage while a few others are in progress.




## Prerequisites

This module has a few dependencies: 

- [Terraform 1.x.x](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [Go](https://golang.org/doc/install)
- [github.com/stretchr/testify/assert](https://github.com/stretchr/testify)
- [github.com/gruntwork-io/terratest/modules/terraform](https://github.com/gruntwork-io/terratest)







## Examples


**IMPORTANT:** Since the `master` branch used in `source` varies based on new modifications, we suggest that you use the release versions [here](https://github.com/clouddrove/terraform-aws-global-accelerator/releases).


### Simple Example
Here is an example of how you can use this module in your inventory structure:
```hcl
  module "global_accelerator" {
    source  = "clouddrove/global-accelerator/aws"
    version = "1.0.0"

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
          endpoint_group_region          = "us-west-2"
          multiple_endpoint_group_region = "eu-west-1"
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
              endpoint_id                    = "arn:aws:elasticloadbalancing:us-west-2:924144197303:loadbalancer/app/alb-test/3ed98b63e2bb9c2a"
              weight                         = 50
            }
          ],
          multiple_endpoint_configuration = [
            {
              client_ip_preservation_enabled = true
              endpoint_id                    = "arn:aws:elasticloadbalancing:eu-west-1:924144197303:loadbalancer/app/alb-test/6b02ebcf5e0396d3"
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
```






## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enabled | Indicates that the accelerator is enabled. Valid values: `true`, `false` | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| flow\_logs\_enabled | Indicates that flow logs are enabled. Valid values: `true`, `false` | `bool` | `false` | no |
| flow\_logs\_s3\_bucket | Flow logs S3 bucket name. Required if `flow_logs_enabled` is `true` | `string` | `null` | no |
| flow\_logs\_s3\_prefix | The prefix for the location where Amazon S3 bucket will store the flow logs. Required if `flow_logs_enabled` is `true` | `string` | `null` | no |
| ip\_address\_type | Type of IP address | `string` | `"IPV4"` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | `[]` | no |
| listeners | Mapping of listener that defintions to create | `any` | n/a | yes |
| listeners\_enabled | Controls if listeners should be created This will affects to only for listeners | `bool` | `true` | no |
| managedby | ManagedBy, eg 'CloudDrove' | `string` | `"hello@clouddrove.com"` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-globle-accelerator"` | no |
| resources\_enabled | Controls if resources should be created. This will affects to all the resources | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| dns\_name | DNS name of the accelerator |
| endpoint\_groups | Map of endpoints created and their specified attributes |
| id | The ARN of the accelerator |
| listeners | Map of listeners created and their specified attributes |




## Testing
In this module testing is performed with [terratest](https://github.com/gruntwork-io/terratest) and it creates a small piece of infrastructure, matches the output like ARN, ID and Tags name etc and destroy infrastructure in your AWS account. This testing is written in GO, so you need a [GO environment](https://golang.org/doc/install) in your system. 

You need to run the following command in the testing folder:
```hcl
  go test -run Test
```



## Feedback 
If you come accross a bug or have any feedback, please log it in our [issue tracker](https://github.com/clouddrove/terraform-aws-global-accelerator/issues), or feel free to drop us an email at [hello@clouddrove.com](mailto:hello@clouddrove.com).

If you have found it worth your time, go ahead and give us a ★ on [our GitHub](https://github.com/clouddrove/terraform-aws-global-accelerator)!

## About us

At [CloudDrove][website], we offer expert guidance, implementation support and services to help organisations accelerate their journey to the cloud. Our services include docker and container orchestration, cloud migration and adoption, infrastructure automation, application modernisation and remediation, and performance engineering.

<p align="center">We are <b> The Cloud Experts!</b></p>
<hr />
<p align="center">We ❤️  <a href="https://github.com/clouddrove">Open Source</a> and you can check out <a href="https://github.com/clouddrove">our other modules</a> to get help with your new Cloud ideas.</p>

  [website]: https://clouddrove.com
  [github]: https://github.com/clouddrove
  [linkedin]: https://cpco.io/linkedin
  [twitter]: https://twitter.com/clouddrove/
  [email]: https://clouddrove.com/contact-us.html
  [terraform_modules]: https://github.com/clouddrove?utf8=%E2%9C%93&q=terraform-&type=&language=
