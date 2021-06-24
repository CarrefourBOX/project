class UsersController < ApplicationController

  def profile
    skip_authorization
  end
end
