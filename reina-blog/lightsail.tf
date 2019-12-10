resource "aws_lightsail_instance" "lightsail_instance" {
  name              = "ReinaBlogInstance"
  availability_zone = local.lightsail.availability_zone
  blueprint_id      = local.lightsail.blueprint_id
  bundle_id         = local.lightsail.bundle_id
  key_pair_name     = aws_lightsail_key_pair.lightsail_key_pair.name
}

resource "aws_lightsail_static_ip" "lightsail_static_ip" {
  name = "ReinaBlogStaticIp"
}

resource "aws_lightsail_static_ip_attachment" "lightsail_static_ip_attachment" {
  instance_name = aws_lightsail_instance.lightsail_instance.name
  static_ip_name = aws_lightsail_static_ip.lightsail_static_ip.name
}

resource "aws_lightsail_key_pair" "lightsail_key_pair" {
  name       = "ReinaBlogInstanceKeyPair"
  public_key = file(local.lightsail.ssh_public_key_path)
}

//resource "aws_lightsail_domain" "lightsail_domain" {
//  domain_name = "pagulikehimono.com"
//}
