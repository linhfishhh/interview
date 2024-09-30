Chuẩn bị 1 cụm cluster có sẵn

Step1: cấu hình metric-server

```bash
kubectl apply -f source/metric-server
```

lưu ý: deployment của metric server phải có option  - --kubelet-insecure-tls
![image](./images/metric-server.png)

Step2: apply manifest

```bash
kubectl apply -f source/app.yml
```
![image](./images/installapp.png)
kiểm tra kết quả

![image](./images/image.png)

