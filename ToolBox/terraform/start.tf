// Provider
provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "JenkinsInstanceProfile"
  role = "JenkinsRestoreRole" // назва ролі для S3
}


// Create EC2 instance
resource "aws_instance" "EC2-Instance" {
  availability_zone      = "eu-north-1a"
  ami                    = "ami-08eb150f611ca277f"
  instance_type          = "t3.large"
  key_name               = var.key_name

  iam_instance_profile = aws_iam_instance_profile.jenkins_profile.name
  vpc_security_group_ids = [aws_security_group.DefaultTerraformSG.id]

  // Create main disk
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 30
    tags = {
      "name" = "root disk"
    }
  }

  tags = {
    Name = "Jenkins"
  }

  user_data = file("files/install_apps.sh")
}

#// Create Elastic IP
#resource "aws_eip" "jenkins_eip" {
#  domain = "vpc"
#}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.EC2-Instance.id
  allocation_id = var.elastic_ip_allocation_id
}

// Create security group
resource "aws_security_group" "DefaultTerraformSG" {
  name        = "DefaultTerraformSG"
  description = "Allow 22, 80, 443, 1433, 5034, 8080 inbound traffic"
}

// Define the ingress rules
resource "aws_security_group_rule" "ingress_rules" {
  for_each = {
    "http"    = { from_port = 80, to_port = 80, description = "Allow HTTP" }
    "https"   = { from_port = 443, to_port = 443, description = "Allow HTTPS" }
    "jenkins" = { from_port = 8080, to_port = 8080, description = "Allow Jenkins" }
    "mssql"   = { from_port = 1433, to_port = 1433, description = "Allow MSSQL" }
    "backend" = { from_port = 5034, to_port = 5034, description = "Allow Backend" }
    "ssh"     = { from_port = 22, to_port = 22, description = "Allow SSH" }
  }

  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.DefaultTerraformSG.id
  description       = each.value.description
}

// Define the egress rule
resource "aws_security_group_rule" "egress_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.DefaultTerraformSG.id
}

// Print public IP
resource "null_resource" "print_ip" {
  provisioner "local-exec" {
    command = "echo Jenkins Public IP: ${aws_eip_association.eip_assoc.public_ip}"
  }
}

// Create S3 bucket for Jenkins backup
resource "aws_s3_bucket" "jenkins_backup" {
  bucket        = "jenkins-backup-den-2025"
  force_destroy = true

  tags = {
    Name        = "Jenkins Backup Bucket"
    Environment = "DiplomaProject"
  }
}

// Block public access to S3 bucket (recommended)
resource "aws_s3_bucket_public_access_block" "block_s3_public" {
  bucket = aws_s3_bucket.jenkins_backup.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

// Enable versioning (optional but useful)
resource "aws_s3_bucket_versioning" "jenkins_backup_versioning" {
  bucket = aws_s3_bucket.jenkins_backup.id

  versioning_configuration {
    status = "Enabled"
  }
}

###############

#resource "null_resource" "upload_jenkins_backup" {
#  triggers = {
#    archive_path = "${path.module}/jenkins_pipelines.tar.gz"
#    timestamp    = timestamp()
#  }

#  provisioner "local-exec" {
#    command = <<EOT
#      echo "Uploading Jenkins backup to S3..."
#      aws s3 cp ${path.module}/jenkins_pipelines.tar.gz \
#      s3://jenkins-backup-den-2025/jenkins_pipelines_${timestamp()}.tar.gz
#    EOT
#  }
#}

resource "null_resource" "upload_jenkins_backup" {
  triggers = {
    always_run = "${timestamp()}" // просто щоб ресурс завжди виконувався
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "Uploading Jenkins backup to S3 with fixed name..."
      aws s3 cp ${path.module}/jenkins_pipelines.tar.gz \
      s3://jenkins-backup-den-2025/jenkins_pipelines.tar.gz --region eu-north-1
    EOT
  }
}

