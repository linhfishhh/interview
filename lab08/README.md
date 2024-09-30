Step1: Khởi tạo VPC
![image](./images/VPC.png)

chọn option vpc and more

![image](./images/vpc1.png)

click chọn create

![image](./images/vpc2.png)

Step2: Tạo launch template

truy cập console dịch vụ EC2 > Autoscaling group > create launch template 

![image](./images/autoscale.png)

điền các thông số rồi ấn create launch template

![image](./images/launchtemplate.png)

![image](./images/launchtemplate1.png)

truy cập màn hình autoscaling group chọn create auto scaling group

![image](./images/autoscale1.png)

chọn VPC tạo ở bước trước > next

![image](./images/autoscale2.png)

chọn attach new loadbalancer để tạo mới loadbalancer và target group
![image](./images/autoscale3.png)

chọn next để tạo resource
![image](./images/autoscale4.png)

chọn option scaling policy để scale instance và chọn metric là scale theo CPU cấu hình này có nghĩa autoscaling sẽ tự động scale theo chỉ số CPU

![image](./images/autoscale5.png)

next qua các step và chọn create

Step3: verify thông tin

truy cập vào màn hình ec2 > load balancer
![image](./images/alb.png)

chờ health chekc thành công và truy cập DNS của ALB
![image](./images/alb2.png)

verify kết quả
![image](./images/alb3.png)

step4: dọn dẹp resource