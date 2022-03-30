data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
    values = [local.vpc_name]
  }
}
