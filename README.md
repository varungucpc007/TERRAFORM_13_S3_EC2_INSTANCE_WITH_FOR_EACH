# TERRAFORM_13_S3_EC2_INSTANCE_WITH_FOR_EACH

## Project Overview

This Terraform project demonstrates how to create AWS S3 buckets and EC2 instances using the `for_each` meta-argument. It is useful when each resource needs a unique key or custom configuration.

## What This Project Creates

- Multiple EC2 instances using `for_each`
- Multiple S3 buckets using `for_each`
- Resource names based on map keys
- Cleaner management of individually named resources

## Technologies Used

| Technology | Purpose |
| --- | --- |
| Terraform | Infrastructure as Code |
| AWS EC2 | Virtual servers |
| AWS S3 | Object storage |
| `for_each` | Map-based resource creation |

## Recommended Files

```text
TERRAFORM_13_S3_EC2_INSTANCE_WITH_FOR_EACH/
├── provider.tf
├── ec2.tf
├── s3.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
└── README.md
```

## for_each Concept

The `for_each` argument creates resources from a map or set.

Example:

```hcl
resource "aws_instance" "server" {
  for_each      = var.instances
  ami           = each.value.ami
  instance_type = each.value.instance_type

  tags = {
    Name = each.key
  }
}
```

## When to Use for_each

Use `for_each` when:

- Resources need unique names
- Resources have different configurations
- You want stable resource tracking by key

## Terraform Commands

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

Type `yes` when prompted.

## Verify Resources

```bash
aws ec2 describe-instances
aws s3 ls
```

## Destroy Resources

```bash
terraform destroy
```

## Important Notes

- `for_each` is better than `count` for uniquely named resources.
- Changing map keys can destroy and recreate resources.
- S3 bucket names must be globally unique.
- Review plans carefully before applying.
