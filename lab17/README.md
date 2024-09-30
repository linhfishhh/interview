chuẩn bị:
- 1 cụm cluster

nếu image nằm trong private repo có thể cấu hình imagePullSecret

Cài đặt ứng dụng
```bash
kubectl create ns techmaster

kubectl apply -f source/manifest.yml -n techmaster
```