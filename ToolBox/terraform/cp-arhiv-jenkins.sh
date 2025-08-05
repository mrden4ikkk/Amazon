#!/bin/bash

# Архів, який хочеш закинути
ARCHIVE_PATH="/home/den4ik/diploma/Amazon/ToolBox/terraform/jenkins_pipelines.tar.gz"

# Отримай ім'я бакету (можеш передавати через змінну чи Terraform output)
BUCKET_NAME="$1"

# Назва файлу в S3
S3_KEY="jenkins-backup-den/jenkins_pipelines.tar.gz"

# Завантажити в S3
aws s3 cp "$ARCHIVE_PATH" "s3://$BUCKET_NAME/$S3_KEY"
