#!/bin/bash

service="nginx"
email="linhfish.dev@gmail.com"
subject="Cảnh báo: dịch vụ $service đã bị dừng"
message="Email cảnh báo về dịch vụ $service đã bị dừng vui lòng kiểm tra và khôi phục lại"

if ! systemctl is-active --quiet $service; then
    echo -e "Subject: $subject\n\n$message" | msmtp $email
fi