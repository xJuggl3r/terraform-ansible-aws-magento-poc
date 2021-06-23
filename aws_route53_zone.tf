resource "aws_route53_zone" "anr4x4" {
  name = var.site_name

  tags = {
    Environment = "dev"
  }
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
  name    = "_4553287aa6b45fbc1f03cd138ad69b13.anr4x4.com.br"
  type    = "CNAME"
  ttl     = "300"
  records = ["56AF8688085B9D0652D765D7B144056B.80860A601CE56262EEBAA350BAFADA7A.a2ca8e1511.ssl.com"]
}

output "name_server" {
  value = aws_route53_zone.anr4x4.name_servers
}
