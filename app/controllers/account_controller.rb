class AccountController < ApplicationController 
  before_filter :set_page

  def set_page
  		@menus[:dashboard][:active] = "active"
  end

  def dashboard
    
  end

end
