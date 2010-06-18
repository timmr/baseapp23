class DashboardController < ApplicationController
  skip_before_filter :authorize_user, :only => [:index]
  
  def index
    # index.html.erb
  end
end
