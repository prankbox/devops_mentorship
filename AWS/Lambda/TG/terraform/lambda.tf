# resource "null_resource" "runner" {
#   provisioner "local-exec" {
#     command     = "cd Libs && ./runner.sh"
#     interpreter = ["/bin/bash", "-c"]
#   }
# }


module "bot_lambda" {
  source = "terraform-aws-modules/lambda/aws"
  #version = "2.7.0"
  # insert the 28 required variables here
  function_name = "telegram-cripto-bot"
  description   = "Gets btc rate"
  handler       = "handler.bot"
  runtime       = "python3.9"
  source_path   = "${path.module}/bot"
  #environment_variables = [var.token]
  environment_variables = {
    TELEGRAM_TOKEN = var.token
  }
  #layers = [module.requests_layer.lambda_layer_arn]

  tags = {
    Name = "tg-bot-lambda"
  }

}

# module "requests_layer" {
#   source = "terraform-aws-modules/lambda/aws"

#   create_layer = true

#   layer_name          = "requests-layer"
#   description         = "Requests"
#   compatible_runtimes = ["python3.8", "python3.9"]
#   source_path         = "${path.module}/vendored"
#   tags = {
#     "Name" = "Layer"
#   }

# }