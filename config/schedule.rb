env :PATH, ENV['PATH']

set :job_template, "bash -l -i -c ':job'"
set :environment, 'production'
set :output, "/u/apps/langtrainer.ru/shared/log/cron_log.log"

every 3.days, :at => '3:30 am' do
   rake "db2fog:backup"
end

# Learn more: http://github.com/javan/whenever
