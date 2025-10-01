
##########################
# ECR Repository
##########################
resource "aws_ecr_repository" "flask_repo" {
  name = "flask-repo"
}

##########################
# ALB & Target Group
##########################
resource "aws_lb" "flask_alb" {
  name               = "flask-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]  ### FIXED: ALB uses alb_sg
  subnets            = [aws_subnet.flask_subnet_a.id, aws_subnet.flask_subnet_b.id]
}

resource "aws_lb_target_group" "flask_tg" {
  name        = "flask-tg"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.flask_vpc.id
  target_type = "ip"

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}