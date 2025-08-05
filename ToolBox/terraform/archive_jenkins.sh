#!/bin/bash

#JENKINS_HOME="$HOME/diploma/Amazon/ToolBox/jenkins"
#ARCHIVE_NAME="$HOME/diploma/Amazon/ToolBox/terraform/jenkins_pipelines.tar.gz"
#BUCKET_NAME=$(terraform output -raw jenkins_backup-den)  # заміни на свій output key

#echo "📦 Архівуємо Jenkins: $JENKINS_HOME"
#tar -czvf "$ARCHIVE_NAME" -C "$JENKINS_HOME" .

#echo "☁️ Завантаження в S3 ($BUCKET_NAME)"
#aws s3 cp "$ARCHIVE_NAME" "s3://$BUCKET_NAME/"
#echo "✅ Успішно завантажено"

###########################
##########################
########################

#!/bin/bash

# === Шлях до Jenkins-папки ===
#JENKINS_HOME="$HOME/diploma/Amazon/ToolBox/jenkins"
#ARCHIVE_NAME="$HOME/diploma/Amazon/ToolBox/terraform/jenkins_pipelines.tar.gz"
#BUCKET_NAME="jenkins-backup-den"  # заміни на свій bucket або отримуй з terraform output

# === Перевірка наявності Jenkins-папки ===
#if [ ! -d "$JENKINS_HOME" ]; then
#  echo "Jenkins-папка не знайдена: $JENKINS_HOME"
#  exit 1
#fi

# === Архівування ===
#echo "Створення архіву з: $JENKINS_HOME"
#tar -czvf "$ARCHIVE_NAME" -C "$JENKINS_HOME" .

#if [ $? -ne 0 ]; then
#  echo "Помилка при архівуванні"
#  exit 2
#fi

# === Перевірка наявності S3-бакету ===
#echo "Перевірка наявності S3-бакету: $BUCKET_NAME"
#aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null

#if [ $? -eq 0 ]; then
#  echo "Завантаження архіву в S3..."
#  aws s3 cp "$ARCHIVE_NAME" "s3://$BUCKET_NAME/"
#  echo "Архів успішно завантажено в S3"
#else
#  echo "S3-бакет '$BUCKET_NAME' не знайдено. Завантаження пропущено."
#fi

#####################
####################
##################

#!/bin/bash

# === Шлях до Jenkins-папки ===
JENKINS_HOME="$HOME/diploma/Amazon/ToolBox/jenkins"
ARCHIVE_NAME="$HOME/diploma/Amazon/ToolBox/terraform/jenkins_pipelines.tar.gz"

# === Перевірка наявності папки ===
if [ ! -d "$JENKINS_HOME" ]; then
  echo "❌ Jenkins-папка не знайдена: $JENKINS_HOME"
  exit 1
fi

# === Архівування ===
echo "Створення архіву з: $JENKINS_HOME"
tar -czvf "$ARCHIVE_NAME" -C "$JENKINS_HOME" .

echo "Архів збережено як: $ARCHIVE_NAME"
