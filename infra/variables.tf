variable "region" {
    description = "AWS region"
    default     = "ap-southeast-1"
}

variable "org" {
    description = "Organization short string"
    default = "lgn"
}

variable "env" {
    description = "Envirionment. E.g. 'dev', 'stg', 'prd'"
}

variable "prefix" {
    description = "Resource name prefix"
    default = "${var.org}-${var.env}-cldviz"
}

variable "cloudviz-account" {
    description = "The account of CloudViz service. As stated in their documentation."
    default = "282762468439"
}

variable "cloudviz-external-id" {
    description = "The External ID of CloudViz service. As stated in their documentation."
}



