terraform {
    cloud {
        organization = "lyngon"
        workspaces {
            name = "${var.prefix}workspace"
            description = "Enabling CloudViz to scan AWS account resources and write architecture diagrams and documentation to S3 bucket."
        }
    }
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.28.0"
        }
    }
    required_version = ">= 0.14.0"
}