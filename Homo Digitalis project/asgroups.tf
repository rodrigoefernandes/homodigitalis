# WEB AUTOSCALING

resource "aws_launch_configuration" "launch_configuration_web" {
  name_prefix = "launch_configuration_web"  
  image_id        = "ami-05fa00d4c63e32376"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.web-sg.id]
  key_name = aws_key_pair.linux_key_pair.key_name
  
  
    root_block_device {
    volume_size = "8"
    
  }  

}

resource "aws_autoscaling_group" "web-asg" {
  name = "web-asg"
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  vpc_zone_identifier = [aws_subnet.web_subnet.id]
  launch_configuration = aws_launch_configuration.launch_configuration_web.name
  
}

// WORKLOAD AUTOSCALING

resource "aws_launch_configuration" "launch_configuration_workload" {
  name = "launch_configuration_workload"
  image_id        = "ami-05fa00d4c63e32376"
  instance_type   = "t2.micro"  
  security_groups = [aws_security_group.workload-sg.id]
  key_name = aws_key_pair.linux_key_pair.key_name
  
  root_block_device {
    volume_size = "8"  
    
  }
    
}

resource "aws_autoscaling_group" "workload-asg" {
  name = "workload-asg"
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  vpc_zone_identifier = [aws_subnet.workload_subnet.id]
  launch_configuration = aws_launch_configuration.launch_configuration_workload.name
  
  }

// DB AUTO SCALING

resource "aws_launch_configuration" "launch_configuration_db" {
  name = "launch_configuration_db"
  image_id        = "ami-05fa00d4c63e32376"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.db-sg.id]
  key_name = aws_key_pair.linux_key_pair.key_name
  root_block_device {
    volume_size = "8"  
    
  }

}

resource "aws_autoscaling_group" "db-asg" {
  name = "db-asg"
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  vpc_zone_identifier = [aws_subnet.db_subnet.id]
  launch_configuration = aws_launch_configuration.launch_configuration_db.name
  
  }

