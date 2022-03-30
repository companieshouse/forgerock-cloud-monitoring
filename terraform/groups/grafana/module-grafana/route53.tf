data "aws_route53_zone" "zone" {
  count        = var.route53_available ? 1 : 0

  name         = var.dns_zone_name
  private_zone = false
}

resource "aws_route53_record" "grafana" {
  count   = var.route53_available ? var.instance_count : 0

  zone_id = data.aws_route53_zone.zone[0].zone_id
  name = "${var.service}-${var.environment}-grafana-${count.index + 1}.${var.dns_zone_name}"
  type    = "A"
  ttl     = "300"
  records = [element(aws_instance.grafana.*.private_ip, count.index)]
}

resource "aws_route53_record" "certificate_validation" {
  count   = var.route53_available ? 1 : 0

  zone_id = data.aws_route53_zone.zone[0].zone_id
  name    = aws_acm_certificate.certificate[0].domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.certificate[0].domain_validation_options[0].resource_record_type
  records = [aws_acm_certificate.certificate[0].domain_validation_options[0].resource_record_value]
  ttl     = 60
}


resource "aws_route53_record" "grafana_load_balancer" {
  count   = var.route53_available ? 1 : 0

  zone_id = data.aws_route53_zone.zone[0].zone_id
  name    = "${var.service}-${var.environment}-grafana.${var.dns_zone_name}"
  type    = "A"

  alias {
    name                   = aws_lb.grafana.dns_name
    zone_id                = aws_lb.grafana.zone_id
    evaluate_target_health = false
  }
}
