provider "aws" {
    region      = var.region
    default_tags {
        tags    = {
            URL: "https://github.com/lyngon/cloudviz"
            ProjectResourcePrefix: "${var.prefix}"
            IaC: "Terraform"
        }
    }
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

data "aws_iam_policy" "read_only" {
    name    = "ReadOnlyAccess"
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
        resources = [aws_sns_topic.new_output.arn]

        condition {
            test     = "ArnLike"
            variable = "aws:SourceArn"
            values   = [aws_s3_bucket.output.arn]
        }
    }
}

resource "aws_iam_role" "cloudviz" {
    name                = "${prefix}role-cloudviz"
    assume_role_policy  = assume_role_policy.assume_role.json
    managed_policy_arns = [ aws_iam_policy.read_only ]
    inline_policy {
        name    = "WriteCloudVizBucket"
        policy  = data.aws_iam_policy_document.write_to_bucket.json
    }
    tags        = {
    }
}

resource "aws_s3_bucket" "output" {
    bucket      = "${var.prefix}s3-bucket"

    tags        = {
        Name    = "CloudViz"
    }
}

resource "aws_sns_topic" "new_output" {
    name            = "${var.prefix}sns-new"
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
    tags        = {
        Name = "${prefix}sns-new-sub-${md5(each.key)}"
        Recipient = each.key
    }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.output.id

  topic {
    topic_arn     = aws_sns_topic.new_output.arn
    events        = ["s3ObjectCreated*"]
  }
}