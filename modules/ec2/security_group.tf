# Capture Username and User Public IP.
data "external" "my_public_ip" {
  program = [coalesce("${path.module}/scripts/my_public_ip.sh")]
}

# EC2 Security Group
resource "aws_security_group" "poc_server" {
  name        = "poc_server"
  description = "SSH and HTTP (8080)"
  vpc_id      = var.VPCID

  ingress {
    description = "SSH from ${data.external.my_public_ip.result["username"]} Public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.external.my_public_ip.result["my_public_ip"]]
  }

  ingress {
    description = "HTTP from ${data.external.my_public_ip.result["username"]} Public IP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [data.external.my_public_ip.result["my_public_ip"]]
  }

  egress {
    description      = "Allow Internet Out"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.ProjectTags, { Name = "${var.ec2NameTag}-sg" }, )
}