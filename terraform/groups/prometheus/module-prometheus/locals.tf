locals {
  ami_root_block_device = tolist(data.aws_ami.prometheus.block_device_mappings)[index(data.aws_ami.prometheus.block_device_mappings.*.device_name, data.aws_ami.prometheus.root_device_name)]
  ami_lvm_block_devices = [
    for block_device in data.aws_ami.prometheus.block_device_mappings :
      block_device if block_device.device_name != data.aws_ami.prometheus.root_device_name
  ]
  certificate_arn = var.route53_available ? aws_acm_certificate_validation.certificate[0].certificate_arn : var.certificate_arn

  acm_certificate_domain_validation_options = (
    var.route53_available ? {
      for dvo in aws_acm_certificate.certificate[0].domain_validation_options : dvo.domain_name => {
        name    = dvo.resource_record_name
        type    = dvo.resource_record_type
        records = [dvo.resource_record_value]
      }
    } : {}
  )
}
