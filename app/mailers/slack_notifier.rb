class SlackNotifier
  class << self
    def deliver(username: nil, channel: nil, webhook: nil, attachments: nil)
      notifier = Slack::Notifier.new(
        webhook,
        channel: channel,
        username: "#{'【※development】' unless Rails.env.production?}#{username}"
        )
        notifier.post attachments: attachments
    end

    def success(file_name: )
      username = "cron実行成功しました"
      channel = Rails.application.credentials.slack[:channel]
      webhook = Rails.application.credentials.slack[:webhook]
      attachments = attachments(file_name: file_name)
      deliver(username: username, channel: channel, webhook: webhook, attachments: attachments)
    end

    def error(file_name: , detail: )
      username = "cronによるエラー通知"
      channel = Rails.application.credentials.slack[:channel]
      webhook = Rails.application.credentials.slack[:webhook]
      attachments = attachments(file_name: file_name, detail: detail)
      deliver(username: username, channel: channel, webhook: webhook, attachments: attachments)
    end

    def attachments(file_name: , detail: nil)
      {
        title: file_name,
        text: detail
      }
    end

  end
end