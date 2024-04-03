variable "region" {
  default = "us-east-1"
}

variable "tf_backend_bucket_name" {
  default = "bibek-devops-gitops-terraform-state"
}


variable "bucket_name" {
  type    = string
  default = "bibek-s3-bucket"
}
