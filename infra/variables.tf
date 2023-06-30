variable "region" {
    description = "AWS region"
    type        = string
    default     = "ap-southeast-1"
}

variable "org" {
    description = "Organization short string"
    type        = string
    default     = "lgn"
}

variable "env" {
    description = "Envirionment. E.g. 'dev', 'stg', 'prd'"
    type        = string
}

variable "project" {
    description = "Short name (slug) for project / stack"
    type        = string  
    default     = "cldviz"
}

variable "prefix" {
    description = "Prefix used for created resource names. "
    type        = string
    default     = "<DEFAULT>"
}

variable "cloudviz_account" {
    description = "The account of CloudViz service. As stated in their documentation as 'Account ID' under 'Settings' > 'Manage AWS Accounts' > 'Add AWS Accounts' > 'Step 1'"
    
    default     = "282762468439"
}

variable "cloudviz_external_id" {
    description = "The External ID of CloudViz service. As stated in their documentation as 'External ID' under 'Settings' > 'Manage AWS Accounts' > 'Add AWS Accounts' > 'Step 1'"
    type        = string
}

variable "notify_emails" {
    description = "List of email addresses to send notifications to when new outputs have been saved."
    type        = list(string)
}


