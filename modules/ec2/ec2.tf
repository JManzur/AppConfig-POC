#Grabbing latest Linux 2 AMI
data "aws_ami" "linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
# Calculate hash of code source directory
data "external" "ec2-files-hash" {
  program = [coalesce("${path.module}/scripts/hash.sh"), "${path.module}/files"]
}

# Zip the API files
data "archive_file" "ec2_init" {
  type        = "zip"
  source_dir  = "${path.module}/files/"
  output_path = "${path.module}/output_files/api_files.zip"
}

#EC2 IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "AppConfigPOCInstanceProfile"
  role = aws_iam_role.ec2_policy_role.name
}

/* Private instance (host the API): */
resource "aws_instance" "poc-ec2" {
  ami                         = data.aws_ami.linux2.id
  instance_type               = var.instance_type["type1"]
  subnet_id                   = var.PublicSubnet[0]
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids      = [aws_security_group.poc_server.id]
  associate_public_ip_address = true

  tags = merge(var.ProjectTags, { Name = "${var.ec2NameTag}" }, )

  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
    tags                  = merge(var.ProjectTags, { Name = "${var.ec2NameTag}-ebs" }, )
  }
}

resource "null_resource" "copyfiles" {
  triggers = {
    hash = data.external.ec2-files-hash.result["hash"]
  }

  connection {
    type        = "ssh"
    host        = aws_instance.poc-ec2.public_ip
    user        = "ec2-user"
    private_key = file(var.local_ssh_key)
    agent       = false
  }

  provisioner "file" {
    source      = data.archive_file.ec2_init.output_path
    destination = "/tmp/api_files.zip"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install unzip -y",
      "sudo yum install nc -y",
      "cd /tmp",
      "unzip api_files.zip",
      "rm api_files.zip",
      "chmod +x installer.sh",
      "chmod +x api.sh",
      "/bin/bash installer.sh"
    ]
  }

  depends_on = [aws_instance.poc-ec2]
}