Step1: Cài đặt nginx trên ubuntu ubuntu:
```bash
sudo apt install nginx -y
```
verity nginx

```bash
systemctl status nginx
```
kết quả:
![image](./images/statusnginx.png)


tắt dịch vụ nginx

```bash
sudo systemctl stop nginx
```

verify dịch vụ nginx đã tắt

```bash
systemctl status nginx
```
![image](./images/stopnginx.png)

step2: Cấu hình xác thực và gửi email với ssmtp

Truy cập vào trang myaccount.google.com để lấy credential của gmail

```bash
sudo apt-get update
sudo apt-get install ssmtp 
```