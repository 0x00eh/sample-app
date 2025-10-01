
##########################
# ECS Auto Scaling
##########################

# Define the scalable target
resource "aws_appautoscaling_target" "flask_service_scaling" {
  max_capacity       = 5    # maximum number of tasks
  min_capacity       = 1    # minimum number of tasks
  resource_id        = "service/${aws_ecs_cluster.flask_cluster.name}/${aws_ecs_service.flask_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Scale out policy (increase tasks when CPU > 70%)
resource "aws_appautoscaling_policy" "flask_scale_out" {
  name               = "flask-scale-out"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.flask_service_scaling.resource_id
  scalable_dimension = aws_appautoscaling_target.flask_service_scaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.flask_service_scaling.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 20.0 //20.0 was setup for test if load balancers are working with the auto scaling in desired threshold.
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

# Scale in policy (automatically handled by TargetTrackingScaling)
# You can optionally define separate policies for more control
