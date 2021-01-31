ActiveRecord::Base.transaction do
  user = User.create(email: 'dev@pulsechecker.net', password: '1234567890')
  user.confirm
end
