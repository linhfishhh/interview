#!/bin/bash

SOURCE_DIR="/home/ducdao/aws"
DEST_DIR="/home/ducdao/aws-backup"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$DEST_DIR/backup_$TIMESTAMP.tar.gz"

if ! command -v tar &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y tar
else
    echo "tar has been installed"
fi

if [ ! -d "$SOURCE_DIR" ]; then
  echo "folder source dir not exist: $SOURCE_DIR"
  exit 1
fi

if [ ! -d "$DEST_DIR" ]; then
  echo "destination dỉr not exist - start run command mkdir: $DEST_DIR"
  mkdir -p "$DEST_DIR"
fi

tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .

if [ $? -eq 0 ]; then
  echo "Backup successfully : $BACKUP_FILE"
else
  echo "backup failed"
  exit 1
fi

echo "Backup process completed!"