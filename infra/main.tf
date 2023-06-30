provider "aws" {
    region      = var.region
    default_tags {
        tags    = {
            URL: "https://github.com/lyngon/cloudviz"
            ResourcesPrefix: "${local.prefix}"
            IaC: "Terraform"
        }
    }
}

locals {
    prefix = var.prefix == "<DEFAULT>" ? "${var.org}-${var.env}-${var.project}" : var.prefix
}

locals {
    new_output_topic_name = "${local.prefix}-sns-new"
}

data "aws_caller_identity" "current" {}


data "aws_iam_policy_document" "assume_role" {
    statement {
        effect          = "Allow"
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

data "aws_iam_policy_document" "write_to_bucket" {
    statement {
        effect      = "Allow"
        actions     = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject",
            "s3:GetBucketLocation"
        ]
        resources   = ["${aws_s3_bucket.output.arn}/*"]
    }
}

data "aws_iam_policy_document" "publish_to_topic" {
    statement {
        effect = "Allow"

        principals {
            type        = "Service"
            identifiers = ["s3.amazonaws.com"]
        }

        actions   = ["SNS:Publish"]
        resources = ["arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:${local.new_output_topic_name}"]

        condition {
            test     = "ArnLike"
            variable = "aws:SourceArn"
            values   = [aws_s3_bucket.output.arn]
        }
    }
}

resource "aws_iam_role" "cloudviz" {
    name                = "${local.prefix}-role-cloudviz"
    assume_role_policy  = data.aws_iam_policy_document.assume_role.json
    managed_policy_arns = [ "arn:aws:iam::aws:policy/ReadOnlyAccess" ]
    inline_policy {
        name    = "WriteCloudVizBucket"
        policy  = data.aws_iam_policy_document.write_to_bucket.json
    }
}

resource "aws_s3_bucket" "output" {
    bucket      = "${local.prefix}-s3-output"
}

resource "aws_sns_topic" "new_output" {
    name            = local.new_output_topic_name
    display_name    = "New CloudViz output"
    policy          = data.aws_iam_policy_document.publish_to_topic.json
    tags            = {

    }
}

resource "aws_sns_topic_subscription" "email-subscription" {
    for_each    = toset(var.notify_emails)
    topic_arn   = aws_sns_topic.new_output.arn
    protocol    = "email"
    endpoint    = each.key
}

resource "aws_s3_bucket_notification" "bucket_notification" {
    bucket = aws_s3_bucket.output.id
    topic {
        topic_arn     = aws_sns_topic.new_output.arn
        events        = ["s3:ObjectCreated*"]
    }
}