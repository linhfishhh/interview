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
resource "aws_launch_template" "launch_template_ondemand" {
    name = "launch_template_ondemand"
    block_device_mappings {
      device_name = "/dev/xvda"
      ebs {
        delete_on_termination = true
        volume_size = 8
        volume_type = "gp2"
      }
    }

    instance_type = "t2.micro"

    image_id = var.asg.ami_id

    vpc_security_group_ids = var.asg.sg_ids
    user_data = base64encode(file("${path.module}/userdata.sh"))
}

resource "aws_autoscaling_group" "asg_ondemand" {
    vpc_zone_identifier = [var.asg.private_subnet_ids[0]]
    name = "ondemand_t2micro_ap_southeast_1a"
    desired_capacity = 1
    min_size = 1
    max_size = 1

    health_check_grace_period = 15
    health_check_type = "EC2"

    termination_policies = ["OldestLaunchTemplate", "OldestInstance"]

    mixed_instances_policy {
      instances_distribution {
        spot_allocation_strategy = "capacity-optimized"
        on_demand_percentage_above_base_capacity = 0     
      }

      launch_template {

        launch_template_specification {
          launch_template_id = aws_launch_template.launch_template_ondemand.id
          version = "$Latest"
        }
        
        override {
          instance_type = "t2.micro"
          weighted_capacity =  "1"
        }
      }
    }

    lifecycle {
        ignore_changes = [ desired_capacity ]
        create_before_destroy = true
    }

}

output "asg_id" {
  value = aws_autoscaling_group.asg_ondemand.arn
}

output "asg_name" {
  value = aws_autoscaling_group.asg_ondemand.name
}