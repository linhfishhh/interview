Step1: chạy 3 node ec2 và cài sẵn docker trên 1 VPC default và Security group mặc định cho phép all traffic truy cập
![image](./images/aws1.png)
kiểm tra docker đã được cài đặt hay chưa

Kết nối đến ec2 thông qua instance connect và kiểm tra docker đã được cài hay chưa
```bash
docker version
```
![image](./images/dockerversion.png)


khởi chạy master node

```bash
docker swarm init
```
![image](./images/dockerswarminit.png)


step2: truy cập vào 2 node còn lại

```bash
docker swarm join --token SWMTKN-1-4pwg1draemkvcmt2eqya3orhluss91n1wr7d092yligmfivwlk-5gz635ceg0m47b6e40iz80p4m 172.31.7.239:2377
```
![image](./images/dockerswarmjoin.png)


qua màn console của node master kiểm tra xem node đã join thành công hay chưa

```bash
docker node ls
```
![image](./images/checknode.png)

step3: tạo mới 1 public docker repository cho việc test

![image](./images/dockerhub.png)


login vào public repository ở các node

```bash
docker login
```

build và push image flask app lên public repository này

```bash
docker build ducdv1/sampleflaskapp:latest . 

docker push ducdv1/sampleflaskapp:latest
```
![image](./images/dockerhub.png)


step3: deploy dockker stack

copy thư mục lab06 vào master node và cd đến lab06

```bash
docker stack deploy -c docker-stack.yml python_crud_stack
```

kiểm tra xem container webapp chạy trên node nào

```bash
docker serivce ls

docker service ps python_crud_stack_application
```
![image](./images/dockerservicels.png)

truy cập vào public ip của node đó để verify kết quả

![image](./images/result1.png)

![image](./images/result.png)
