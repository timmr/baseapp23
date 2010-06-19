configatron.configure_from_yaml("config/config.yml", :hash => Rails.env)

# should use info of config.yml therefore configured here

ExceptionNotification::Notifier.exception_recipients = [configatron.support_email]
