data "aws_route53_zone" "zone" {
  count        = var.route53_available ? 1 : 0

  name         = var.dns_zone_name
  private_zone = false
}

resource "aws_route53_record" "prometheus" {
  count   = var.route53_available ? var.instance_count : 0

  zone_id = data.aws_route53_zone.zone[0].zone_id
  name    = "${var.service}-${var.environment}-prometheus-${count.index + 1}.${var.dns_zone_name}"
  type    = "A"
  ttl     = "300"
  records = [element(aws_instance.prometheus.*.private_ip, count.index)]
}

resource "aws_route53_record" "certificate_validation" {
  for_each = local.acm_certificate_domain_validation_options

  allow_overwrite = true
  zone_id         = data.aws_route53_zone.zone[0].zone_id
  name            = each.value.name
  type            = each.value.type
  records         = each.value.records
  ttl             = 60
}

resource "aws_route53_record" "prometheus_load_balancer" {
  count   = var.route53_available ? 1 : 0

  zone_id = data.aws_route53_zone.zone[0].zone_id
  name    = "${var.service}-${var.environment}-prometheus.${var.dns_zone_name}"
  type    = "A"

  alias {
    name                   = aws_lb.prometheus.dns_name
    zone_id                = aws_lb.prometheus.zone_id
    evaluate_target_health = false
  }
}
