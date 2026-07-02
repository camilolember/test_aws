resource "aws_s3_bucket" "webapp_bucket" {
  bucket = "webapp_bucket"
}

resource "aws_s3_bucket" "logs_bucket" {
  bucket = "logs_bucket"
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled = true
  origin {
    domain_name              = aws_s3_bucket.webapp_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = aws_s3_bucket.webapp_bucket.id
  }
  
  logging_config {
    bucket = aws_s3_bucket.logs_bucket.bucket_domain_name
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.webapp_bucket.id

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

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }
  
  viewer_certificate {
    cloudfront_default_certificate = true
  }

}
