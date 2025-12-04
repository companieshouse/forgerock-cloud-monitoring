[
  {
    "name": "${task_name}",
    "image": "${aws_ecr_url}:${tag}",
    "environment": [
      {
        "name": "ORIGIN",
        "value": "${fidc_url}"
      },
      {
        "name": "LOG_SOURCE",
        "value": "${log_source}"
      },
      {
        "name": "LOG_FREQUENCY",
        "value": "${log_frequency}"
      }
    ],
    "secrets": [
      {
        "name": "API_KEY_SECRET",
        "valueFrom": "${fidc_api_key_secret}"
      },
      {
        "name": "API_KEY_ID",
        "valueFrom": "${fidc_api_key_id}"
      },
    ]
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