# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  def destroy
    @connected_with = session[:connected_with]
    super
  end
end
