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

