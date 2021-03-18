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
        "name": "API_KEY_ID",
        "value": "${fidc_api_key_id}"
      },
      {
        "name": "API_KEY_SECRET",
        "value": "${fidc_api_key_secret}"
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