#!/bin/bash

ARCHIVE_PATH="/home/den4ik/diploma/Amazon/ToolBox/terraform/jenkins_pipelines.tar.gz"

BUCKET_NAME="$1"

S3_KEY="jenkins-backup-den/jenkins_pipelines.tar.gz"

aws s3 cp "$ARCHIVE_PATH" "s3://$BUCKET_NAME/$S3_KEY"
