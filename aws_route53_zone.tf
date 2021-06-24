resource "aws_route53_zone" "anr4x4" {
  name = var.site_name

  tags = {
    Environment = "dev"
  }

  depends_on = [
    aws_instance.web
  ]
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.anr4x4.zone_id
  name    = "www.anr4x4.com.br"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.web.public_ip]
}

resource "aws_route53_record" "main" {
  zone_id = aws_route53_zone.anr4x4.zone_id
  name    = ""
  type    = "A"
  ttl     = "300"
  records = [aws_instance.web.public_ip]
}

resource "aws_route53_record" "cert" {
  zone_id = aws_route53_zone.anr4x4.zone_id
  name    = "${var.cert_value}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${var.cert_key}"]
}

resource "aws_route53_record" "wwwcert" {
  zone_id = aws_route53_zone.anr4x4.zone_id
  name    = "${var.cert_value}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${var.cert_key}"]
}

output "name_server" {
  value = aws_route53_zone.anr4x4.name_servers
}
