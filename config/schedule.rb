set :output, 'log/crontab.log'
rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env

#プロジェクト作成
every 1.day, :at => '10:00 am' do
  rake "task_projects:new_projects"
end

#作業時間記録
every 1.day, :at => ('6'..'23').to_a.collect {|x| ["#{x}:00","#{x}:10","#{x}:20","#{x}:30","#{x}:40","#{x}:50"]}.flatten do
  rake "task_time_entries:new_time_entries"
end

#作業時間記録⇨イシュー作成の順番
#イシュー作成
every 1.day, :at => ('6'..'23').to_a.collect {|x| ["#{x}:05","#{x}:15","#{x}:25","#{x}:35","#{x}:45","#{x}:55"]}.flatten do
  rake "task_issues:new_issues"
end

#バージョン作成
every 1.day, :at => '10:05 am' do
  rake "task_versions:new_versions"
end

#プロジェクトメンバー作成
every 1.day, :at => '10:10 am' do
  rake "task_users_project_has:new_users_project_has"
end

#ユーザー作成
every 1.day, :at => '10:15 am' do
  rake "task_users:new_users"
end


