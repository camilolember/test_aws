#bucket for app
resource "aws_s3_bucket" "app_bucket" {
  bucket = "app_bucket"

  tags = {
    Name        = "app_bucket"
    Environment = "Dev"
  }
}

#bucket for logs
resource "aws_s3_bucket" "logs_bucket" {
  bucket = "logs_bucket"

  tags = {
    Name        = "logs_bucket"
    Environment = "Dev"
  }
}

#cloudfront origin access control
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "oac"
  description                       = "OAC  Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

#cloudfront distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.app_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = aws_s3_bucket.app_bucket.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.app_bucket.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  
  logging_configuration {
    bucket = aws_s3_bucket.logs_bucket
  }
}




