def sign_in(user = User.make)
  controller.current_user = user
end

def sign_in_as_admin(user = User.make(:admin))
  controller.current_user = user
end

def sign_out
  controller.current_user = nil
end
