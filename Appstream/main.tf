locals {
  region           = var.region
  project_name     = var.project_name
  environment      = var.environment
  costcenter       = var.costcenter
  owner            = var.owner
  createdby        = var.createdby
  data_sensitivity = var.data_sensitivity
}


# create vpc module
module "vpc" {
  source                            = "../modules/vpc"
  region                            = local.region
  project_name                      = local.project_name
  environment                       = local.environment
  costcenter                        = local.costcenter
  createdby                         = local.createdby
  data_sensitivity                  = local.data_sensitivity
  vpc_cidr                          = var.vpc_cidr
  public_subnet_az1_cidr            = var.public_subnet_az1_cidr
  public_subnet_az2_cidr            = var.public_subnet_az2_cidr
  private_appstream_subnet_az1_cidr = var.private_appstream_subnet_az1_cidr
  private_appstream_subnet_az2_cidr = var.private_appstream_subnet_az2_cidr
  security_group_ids                = [module.security_group.appstream_security_group_id, module.security_group.appstream_vpc_endpoint_sg_id]
  appstream_sg_ids                  = [module.security_group.appstream_vpc_endpoint_sg_id]
}

# create nat-gateway module
module "nat-gateway" {
  source                          = "../modules/nat-gateway"
  region                          = local.region
  project_name                    = local.project_name
  environment                     = local.environment
  costcenter                      = local.costcenter
  createdby                       = local.createdby
  data_sensitivity                = local.data_sensitivity
  public_subnet_az1_id            = module.vpc.public_subnet_az1_id
  internet_gateway                = module.vpc.internet_gateway
  public_subnet_az2_id            = module.vpc.public_subnet_az2_id
  vpc_id                          = module.vpc.vpc_id
  private_appstream_subnet_az1_id = module.vpc.private_appstream_subnet_az1_id
  private_appstream_subnet_az2_id = module.vpc.private_appstream_subnet_az2_id
  public_subnet_ids               = [module.vpc.public_subnet_az1_id, module.vpc.public_subnet_az2_id]
  security_group_ids              = [module.security_group.appstream_security_group_id, module.security_group.appstream_vpc_endpoint_sg_id]
}

# create security groups module
module "security_group" {
  source           = "../modules/security-groups"
  project_name     = local.project_name
  environment      = local.environment
  costcenter       = local.costcenter
  createdby        = local.createdby
  data_sensitivity = local.data_sensitivity
  vpc_id           = module.vpc.vpc_id
  ingress_cidr     = var.ingress_cidr
}



# create appstream module
module "app-stream" {
  source                                = "../modules/app-stream"
  project_name                          = local.project_name
  environment                           = local.environment
  costcenter                            = local.costcenter
  owner                                 = local.owner
  createdby                             = local.createdby
  data_sensitivity                      = local.data_sensitivity
  appstream_instance_type               = var.appstream_instance_type
  appstream_image_name                  = var.appstream_image_name
  iam_role_arn                          = module.iam.appstream_role_arn
  private_appstream_subnet_az1_id       = module.vpc.private_appstream_subnet_az1_id
  private_appstream_subnet_az2_id       = module.vpc.private_appstream_subnet_az2_id
  private_subnet_ids                    = [module.vpc.private_appstream_subnet_az1_id, module.vpc.private_appstream_subnet_az2_id]
  security_group_ids                    = [module.security_group.appstream_security_group_id, module.security_group.appstream_vpc_endpoint_sg_id]
  appstream_usage_report_s3_bucket_name = module.s3_bucket.appstream_usage_report_s3_bucket_name
  appstream_usage_report_s3_bucket_arn  = module.s3_bucket.appstream_usage_report_s3_bucket_arn
  appstream_role_arn                    = module.iam.appstream_role_arn
  vpce_id                               = module.vpc.vpce_id
  //appstream_security_group_id = module.security_group.appstream_security_group_id

}



# create iam module
module "iam" {
  source                  = "../modules/iam"
  project_name            = local.project_name
  environment             = local.environment
  costcenter              = local.costcenter
  createdby               = local.createdby
  owner                   = local.owner
  data_sensitivity        = local.data_sensitivity
  cloud_trail_bucket_name = var.cloud_trail_bucket_name
  appstream_stack_arn     = module.app-stream.appstream_stack_arn
}


# creates s3 bucket 
module "s3_bucket" {
  source                                = "../modules/s3"
  project_name                          = local.project_name
  environment                           = local.environment
  costcenter                            = local.costcenter
  createdby                             = local.createdby
  data_sensitivity                      = local.data_sensitivity
  cloud_trail_bucket_name               = var.cloud_trail_bucket_name
  cloud_watch_bucket_name               = var.cloud_watch_bucket_name
  appstream_usage_report_s3_bucket_name = var.appstream_usage_report_s3_bucket_name
}
