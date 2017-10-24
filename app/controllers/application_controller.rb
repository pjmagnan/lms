# Application controller
#  Base for all controllers
class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_action :require_login
  before_action :set_paper_trail_whodunnit
  layout :layout_for_role

  responders :flash

  def not_authenticated
    redirect_to login_path
  end

  private

  def layout_for_role
    if current_user.admin?
      'admin'
    elsif current_user.instructor?
      'instructor'
    elsif current_user.student?
      'student'
    else
      'application'
    end
  end
end
