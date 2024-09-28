step1: cài đặt terraform cli
```bash
choco install terraform
```
### terraform sẽ tự đọc cấu hình credentials từ khi đã cấu hình aws cli

step2: kiểm tra những resource sẽ được tạo

```bash
terraform plan
```

step3: triển khai resource
```bash
terraform apply --auto-approve
```

step4: dọn dẹp reosurce

```bash
terraform destroy
```