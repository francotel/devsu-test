module "kms" {
  source = "terraform-aws-modules/kms/aws"

  description = "KMS for Devsu test"
  key_usage   = "ENCRYPT_DECRYPT"

  # Policy

  # Aliases
  aliases = ["devsu/${var.env}"]

  tags = {
    Alias = "devsu/${var.env}"
  }
}

module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name            = "ecr-${var.project}-${var.env}"
  repository_encryption_type = "KMS"
  repository_kms_key         = module.kms.key_arn
  repository_type            = "private"


  # repository_read_write_access_arns = ["arn:aws:iam::012345678901:role/terraform"]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Name = "ecr-${var.project}-${var.env}"
  }
}

module "secrets-manager" {

  source = "lgallard/secrets-manager/aws"

  secrets = {
    secret-kv-sonarcloud = {
      description = "This is a key/value secret sonarcloud"
      kms_key_id  = module.kms.key_id
      secret_key_value = {
        Organization = "francotel"
        Host         = "sonarcloud.io"
        Project      = "devsu-test"
        sonartoken   = "766f4d8b0298fc17b93add5c2f15cfb48b018a16"
      }
      recovery_window_in_days = 7
    },
  }
}