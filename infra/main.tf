provider "aws" {
    region      = var.region
    default_tags {
        tags    = {
            URL: "https://github.com/lyngon/cloudviz"
            ProjectResourcePrefix: "${var.prefix}"
        }
    }
}

data "aws_iam_policy_document" "assume_role" {
    statement {
        actions         = ["sts:AssumeRole"]
        principals {
            type        = "AWS"
            # identifiers = ["arn:aws:iam::${var.cloudviz_account}:root"]
            identifiers = [ var.cloudviz_account ]
        }
        condition {
            test        = "StringEquals"
            variable    = "sts:ExternalId"
            values      = [ var.cloudviz_external_id ]

        }
    }
}

data "aws_iam_policy" "read_only" {
    name    = "ReadOnlyAccess"
}

resource "aws_iam_role" "cloudviz" {
    name = "${prefix}-role-cloudviz"
    assume_role_policy = assume_role_policy.assume_role.json
    managed_policy_arns = [ aws_iam_policy.read_only ]
}