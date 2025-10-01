
##########################
# ECS Service
##########################
resource "aws_ecs_service" "flask_service" {
  name            = "flask-service"
  cluster         = aws_ecs_cluster.flask_cluster.id
  task_definition = aws_ecs_task_definition.flask_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.flask_subnet_a.id, aws_subnet.flask_subnet_b.id]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.flask_tg.arn
    container_name   = "flask-app"
    container_port   = 5000
  }

  depends_on = [aws_cloudwatch_log_group.flask_app]
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 60
}

##########################
# Route53 Record
##########################
# resource "aws_route53_record" "flask_dns" {
#   zone_id = "Z05373479NAJ7493CR3V"
#   name    = "mind.linkpc.net" #change with your domain.
#   type    = "A"

#   alias {
#     name                   = aws_lb.flask_alb.dns_name
#     zone_id                = aws_lb.flask_alb.zone_id
#     evaluate_target_health = true
#   }
# }
