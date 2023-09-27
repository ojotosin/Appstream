# network acl
resource "aws_network_acl" "network_acl" {
  vpc_id = var.vpc_id

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.ingress_cidr
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-${var.costcenter}-${var.createdby}-${var.data_sensitivity}-network-acl"
  }
}
