#!/bin/bash

service="nginx"
email="linhfish.dev@gmail.com"
subject="Cảnh báo: dịch vụ $service đã bị dừng"
message="Email cảnh báo về dịch vụ $service đã bị dừng vui lòng kiểm tra và khôi phục lại"

if dpkg -l | grep -q mailutils; then
    echo "mailutils đã được cài đặt."
else
    echo "mailutils chưa được cài đặt."
    sudo apt-get install mailutils
fi

if ! systemctl is-active --quiet $service; then
    echo -e "$message" | mail -s "$subject" $email
fi