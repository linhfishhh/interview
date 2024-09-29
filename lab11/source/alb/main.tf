variable "environment" {
  
}

variable "asg" {
  type = object({
    private_subnet_ids = list(string)
    private_subnet_zones = list(string)
    sg_ids = list(string)
    ami_id = string
  })
}

variable "alb" {
  type = object({
    vpc_id = string
    public_subnet_ids = list(string)
  })
}

module "asg" {
    source = "./asg"
    asg = var.asg
    environment = var.environment
}

resource "aws_security_group" "alb_sg" {
  name   = "alb_sg"
  vpc_id = var.alb.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "alb" {
  name               = "interviewALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.alb.public_subnet_ids
}


resource "aws_lb_target_group" "my_tg" {
  name        = "my-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.alb.vpc_id
  target_type = "instance"
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}

resource "aws_autoscaling_attachment" "asg_tg" {
  autoscaling_group_name = module.asg.asg_name
  lb_target_group_arn    = aws_lb_target_group.my_tg.arn
}