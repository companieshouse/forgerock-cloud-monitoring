data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = "${var.account_name}-${var.region}.terraform-state.ch.gov.uk"
    key    = "aws-common-infrastructure-terraform/common-${var.region}/networking.tfstate"
    region = var.region
  }
}
