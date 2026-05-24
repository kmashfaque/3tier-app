locals {
  project_name = "3-tier-aws-terraform"
  resource_tag = "3TierApp"
}

locals {
  availability_zone_1 = data.aws_availability_zones.available.names[0]
  availability_zone_2 = data.aws_availability_zones.available.names[1]
}
