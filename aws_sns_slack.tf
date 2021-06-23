resource "aws_sns_topic" "Teste-ChatBot-CPU" {
  name = "my-sns"
}

module "notify_slack" {
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "~> 4.0"

  sns_topic_name = "Teste-ChatBot-CPU"

  slack_webhook_url = "https://hooks.slack.com/services/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"
  slack_channel     = "tcb-chatbot"
  slack_username    = "criptonauta"

  depends_on = [aws_sns_topic.Teste-ChatBot-CPU]
}

