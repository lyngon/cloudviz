# CloudViz

Terraform IaC for resources needed for [CloudViz](https://app.cloudviz.io) integration.

Created Resources:

- Role that CloudViz services can assume.
- S3 Bucket that CloudViz can write diagrams to.
- Permissions for the CloudViz role to scan the account (`ReadOnlyAccess`) and write to the S3 bucket.
- SNS topic that is notified when new diagram is written.
- Email subscription to SNS topic.

Outputs:

- `iam_role_arn` - The ARN of the role that CloudViz will assume. Configure this for 'IAM Role ARN' under 'Settings' > 'Manage AWS Accounts' > 'Add AWS Accounts' > 'Step 4'
- `file_storage` - The bucket that CloudViz will write its outputs to. Configure this for 'File Storage' under 'Settings' > 'Automation Profile' > 'Create Automation Profile'

Variables:

- `region` - AWS region (default: `ap-southeast-1`)
- `org` - Organization short string (default: `lgn`)
- `env` - Environment. E.g. `dev`, `stg`, `prd`
- `project` - Short name (slug) for project / stack. (default: `cldviz`)
- `prefix` - Prefix used for created resource names (default: `${org}-${env}-${project}`)
- `cloudviz_account` - The account of CloudViz service. As stated in their documentation as 'Account ID' under 'Settings' > 'Manage AWS Accounts' > 'Add AWS Accounts' > 'Step 1' (default: `282762468439`)
- `cloudviz_external_id` - The External ID of CloudViz service. As stated in their documentation as 'External ID' under 'Settings' > 'Manage AWS Accounts' > 'Add AWS Accounts' > 'Step 1'
- `notify_emails` - List of email addresses to send notifications to when new outputs have been saved.
