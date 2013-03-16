if Rails.env == 'production'
  DB2Fog.config = {
      aws_access_key_id: ENV['AWS_HTTPLAB_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_HTTPLAB_SECRET_ACCESS_KEY'],
      directory: 'langtrainer-ru-backups',
      provider: 'AWS'
      #fog_region: "eu-west-1"
  }
end
