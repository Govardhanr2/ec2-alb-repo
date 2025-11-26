
module "networking" {
  source   = "./modules/networking"
  vpc_cidr = var.vpc_cidr
}

module "security" {
  source = "./modules/security"
  vpc_id = module.networking.vpc_id
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
}

module "ec2" {
  source                    = "./modules/ec2"
  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  private_subnet_a_id       = module.networking.private_subnet_a_id
  private_subnet_b_id       = module.networking.private_subnet_b_id
  ec2_sg_id                 = module.security.ec2_sg_id
  domain_name               = var.domain_name
  instance_profile_name     = module.cloudwatch.instance_profile_name
  cloudwatch_config_content = module.cloudwatch.cloudwatch_config_content
}

module "acm" {
  source                  = "./modules/acm"
  validation_record_fqdns = module.route53.validation_record_fqdns
}

module "route53" {
  source                    = "./modules/route53"
  domain_name               = var.domain_name
  zone_id                   = var.zone_id
  alb_dns_name              = module.alb.alb_dns_name
  alb_zone_id               = module.alb.alb_zone_id
  domain_validation_options = module.acm.domain_validation_options
}

module "alb" {
  source              = "./modules/alb"
  vpc_id              = module.networking.vpc_id
  public_subnet_a_id  = module.networking.public_subnet_a_id
  public_subnet_b_id  = module.networking.public_subnet_b_id
  alb_sg_id           = module.security.alb_sg_id
  web1_id             = module.ec2.web1_id
  web2_id             = module.ec2.web2_id
  domain_name         = var.domain_name
  acm_certificate_arn = module.acm.acm_certificate_arn
}
