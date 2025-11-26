
# Separate Docker and Instance target groups
resource "aws_lb_target_group" "docker" {
  name     = "docker-tg"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
    path                = "/health"
    matcher             = "200"
    protocol            = "HTTP"
    port                = "traffic-port"
  }
}

resource "aws_lb_target_group" "instance" {
  name     = "instance-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
    path                = "/health"
    matcher             = "200"
    protocol            = "HTTP"
    port                = "traffic-port"
  }
}

resource "aws_lb_target_group" "docker1_tg" {
  name     = "docker1-tg"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
    path                = "/health"
    matcher             = "200"
    protocol            = "HTTP"
    port                = "traffic-port"
  }
}

resource "aws_lb_target_group" "docker2_tg" {
  name     = "docker2-tg"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
    path                = "/health"
    matcher             = "200"
    protocol            = "HTTP"
    port                = "traffic-port"
  }
}

resource "aws_lb_target_group" "instance1_tg" {
  name     = "instance1-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
    path                = "/health"
    matcher             = "200"
    protocol            = "HTTP"
    port                = "traffic-port"
  }
}

resource "aws_lb_target_group" "instance2_tg" {
  name     = "instance2-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
    path                = "/health"
    matcher             = "200"
    protocol            = "HTTP"
    port                = "traffic-port"
  }
}

# Attach both instances to both target groups (for demo; you can split if needed)
resource "aws_lb_target_group_attachment" "docker_1" {
  target_group_arn = aws_lb_target_group.docker.arn
  target_id        = var.web1_id
  port             = 8081
}
resource "aws_lb_target_group_attachment" "docker_2" {
  target_group_arn = aws_lb_target_group.docker.arn
  target_id        = var.web2_id
  port             = 8081
}
resource "aws_lb_target_group_attachment" "instance_1" {
  target_group_arn = aws_lb_target_group.instance.arn
  target_id        = var.web1_id
  port             = 80
}
resource "aws_lb_target_group_attachment" "instance_2" {
  target_group_arn = aws_lb_target_group.instance.arn
  target_id        = var.web2_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "docker1_tg_attachment" {
  target_group_arn = aws_lb_target_group.docker1_tg.arn
  target_id        = var.web1_id
  port             = 8081
}

resource "aws_lb_target_group_attachment" "docker2_tg_attachment" {
  target_group_arn = aws_lb_target_group.docker2_tg.arn
  target_id        = var.web2_id
  port             = 8081
}

resource "aws_lb_target_group_attachment" "instance1_tg_attachment" {
  target_group_arn = aws_lb_target_group.instance1_tg.arn
  target_id        = var.web1_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "instance2_tg_attachment" {
  target_group_arn = aws_lb_target_group.instance2_tg.arn
  target_id        = var.web2_id
  port             = 80
}

# ALB listener rules for host-based routing
resource "aws_lb_listener_rule" "alb_docker" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.docker.arn
  }
  condition {
    host_header {
      values = ["ec2-alb-docker.${var.domain_name}"]
    }
  }
}

resource "aws_lb_listener_rule" "alb_docker1" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 101
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.docker1_tg.arn
  }
  condition {
    host_header {
      values = ["ec2-docker1.${var.domain_name}"]
    }
  }
}

resource "aws_lb_listener_rule" "alb_docker2" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 102
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.docker2_tg.arn
  }
  condition {
    host_header {
      values = ["ec2-docker2.${var.domain_name}"]
    }
  }
}

resource "aws_lb_listener_rule" "alb_instance" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 200
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instance.arn
  }
  condition {
    host_header {
      values = ["ec2-alb-instance.${var.domain_name}"]
    }
  }
}

resource "aws_lb_listener_rule" "alb_instance1" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 201
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instance1_tg.arn
  }
  condition {
    host_header {
      values = ["ec2-instance1.${var.domain_name}"]
    }
  }
}

resource "aws_lb_listener_rule" "alb_instance2" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 202
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instance2_tg.arn
  }
  condition {
    host_header {
      values = ["ec2-instance2.${var.domain_name}"]
    }
  }
}

resource "aws_lb" "alb" {
  name               = "static-site-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [var.public_subnet_a_id, var.public_subnet_b_id]
  security_groups    = [var.alb_sg_id]
}

resource "aws_lb_target_group" "tg" {
  name     = "static-site-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
    path                = "/health"
    matcher             = "200"
    protocol            = "HTTP"
    port                = "traffic-port"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group_attachment" "ec2_attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.web1_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "ec2_attach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.web2_id
  port             = 80
}
