namespace :langtrainer do
  desc 'Makes laser user to admin.'
  task make_last_user_admin: :environment do
    user = User.last
    user.roles << Role.first
    user.save!
  end
end
