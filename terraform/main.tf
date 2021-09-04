

provider "aws" {
  region = "us-west-2"
}


resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "archive_file" "lambda_my_function" {
  type        = "zip"
  source_file = "${path.module}/../target/release/bootstrap"
  output_path = "${path.module}/../lambda.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename      = data.archive_file.lambda_my_function.output_path
  function_name = "brew_book_get_api"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "hello.handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256(data.archive_file.lambda_my_function.output_path)

  runtime = "provided.al2"
}
