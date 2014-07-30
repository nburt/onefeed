def create_user(attributes = {})
  user = new_user(attributes)
  user.save!
  user
end

def new_user(attributes= {})
  defaults = {
    first_name: 'Nathanael',
    last_name: 'Burt',
    email: 'nate@example.com',
    password: 'password'
  }
  User.new(defaults.merge(attributes))
end
