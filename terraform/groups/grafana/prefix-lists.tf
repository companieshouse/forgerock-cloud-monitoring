data "aws_ec2_managed_prefix_list" "admin_cidrs" {
  filter {
    name   = "prefix-list-name"
    values = [var.admin_cidrs_prefix_list_name]
  }
}
