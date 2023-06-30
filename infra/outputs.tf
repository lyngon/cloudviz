output "iam_role_arn" {
    description = "The ARN of the role that CloudViz will assume. Configure this for 'IAM Role ARN' under 'Settings' > 'Manage AWS Accounts' > 'Add AWS Accounts' > 'Step 4'"
    value = aws_iam_role.cloudviz.arn
}

output "file_storage" {
    description = "The bucket that CloudViz will write its outputs to. Configure this for 'File Storage' under 'Settings' > 'Automation Profile' > 'Create Automation Profile'"
    value = aws_s3_bucket.output.bucket
}