[
  {
    "name": "${task_name}",
    "image": "${aws_ecr_url}:${tag}",
    "environment": [
      {
        "name": "AWS_ACCESS_KEY_ID",
        "value": "${aws_access_key_id}"
      },
      {
        "name": "AWS_SECRET_ACCESS_KEY",
        "value": "${aws_secret_access_key}"
      },
      {
        "name": "CLOUDWATCH_NAMESPACE",
        "value": "${cloudwatch_namespace}"
      },
      {
        "name": "CLOUDWATCH_REGION",
        "value": "${cloudwatch_region}"
      },
      {
        "name": "CLOUDWATCH_PUBLISH_TIMEOUT",
        "value": "${cloudwatch_publish_timeout}"
      },
      {
        "name": "PROMETHEUS_SCRAPE_INTERVAL",
        "value": "${prometheus_scrape_interval}"
      },
      {
        "name": "PROMETHEUS_SCRAPE_URL",
        "value": "https://${fidc_api_key_id}:${fidc_api_key_secret}@${prometheus_scrape_url}"
      },
      {
        "name": "CERT_PATH",
        "value": ""
      },
      {
        "name": "KEY_PATH",
        "value": ""
      },
      {
        "name": "ACCEPT_INVALID_CERT",
        "value": "true"
      },
      {
        "name": "INCLUDE_METRICS",
        "value": ""
      },
      {
        "name": "EXCLUDE_METRICS",
        "value": ""
      },
      {
        "name": "INCLUDE_DIMENSIONS_FOR_METRICS",
        "value": ""
      },
      {
        "name": "EXCLUDE_DIMENSIONS_FOR_METRICS",
        "value": ""
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${cloudwatch_log_group_name}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "${cloudwatch_log_prefix}"
      }
    }
  }
]