class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  unless ActionController::Base.consider_all_requests_local
    rescue_from Exception, :with => :render_error
    rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
    rescue_from ActionController::RoutingError, :with => :render_not_found
    rescue_from ActionController::UnknownController, :with => :render_not_found
    rescue_from ActionController::UnknownAction, :with => :render_not_found
  end 

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
  	sign_out
  	super
  end

  private

  def render_not_found(exception)
    log_error(exception)
    render :template => "/error/404.html.erb", :status => 404
  end

  def render_error(exception)
    log_error(exception)
    render :template => "/error/500.html.erb", :status => 500
  end
end
