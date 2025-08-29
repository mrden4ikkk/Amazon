#!/bin/bash

sudo systemctl stop jenkins

# === Шлях до Jenkins-папки ===
JENKINS_HOME="/var/lib/jenkins"
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
