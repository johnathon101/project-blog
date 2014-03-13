module Authenticate
  def auth_user
    if user.is_auth=0
      raise "I am sorry, you are not logged in."
    elsif user.is_auth>1
      raise "There is something wrong."
    end       
  end
end