def sign_in(user = User.make)
  controller.current_user = user
end

def sign_out
  controller.current_user = nil
end
