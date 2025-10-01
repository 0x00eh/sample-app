
##########################
# Listeners
##########################
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.flask_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    #type = "redirect"
    type             = "forward"
    target_group_arn = aws_lb_target_group.flask_tg.arn
    #redirect {
    #   port        = "443"
    #   protocol    = "HTTPS"
    #   status_code = "HTTP_301"
    # }
  }
}

# resource "aws_lb_listener" "https_listener" {
#   load_balancer_arn = aws_lb.flask_alb.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   #certificate_arn   = "arn:aws:acm:us-east-1:261853455073:certificate/e80a7578-8a8e-40f4-8290-14550c03b6ed" #old one
#   certificate_arn   = "arn:aws:acm:us-east-1:261853455073:certificate/0d5a74fd-8ac2-4374-aeb8-1e78de37aa16"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.flask_tg.arn
#   }
# }
