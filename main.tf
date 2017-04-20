variable "aws_region" {
  default = "us-east-2"
}

variable "gcp_region" {
  default = "us-central1"
}

provider "aws" {
  region = "${var.aws_region}"
}

provider "google" {
  region = "${var.gcp_region}"
}
