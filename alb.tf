# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name   = "${var.friendly_name_prefix}-sg-alb"
  vpc_id = aws_vpc.main[0].id

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

  tags = merge(
    { Name = "${var.friendly_name_prefix}-sg-alb" },
    var.common_tags
  )
}

# Target Groups
resource "aws_lb_target_group" "blue_tg" {
  name     = "${var.friendly_name_prefix}-blue-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main[0].id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group" "green_tg" {
  name     = "${var.friendly_name_prefix}-green-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main[0].id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Register Instances to Target Groups
resource "aws_lb_target_group_attachment" "blue" {
  count            = 2
  target_group_arn = aws_lb_target_group.blue_tg.arn
  target_id        = aws_instance.blue[count.index].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "green" {
  count            = 2
  target_group_arn = aws_lb_target_group.green_tg.arn
  target_id        = aws_instance.green[count.index].id
  port             = 80
}

# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "${var.friendly_name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = false

  tags = merge(
    { Name = "${var.friendly_name_prefix}-alb" },
    var.common_tags
  )
}

# ALB Listener (Initially points to Blue)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.blue_tg.arn   # Switch to green_tg for green deployment
#   }
# }

 default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green_tg.arn # Switch to green_tg for green deployment
  }
}