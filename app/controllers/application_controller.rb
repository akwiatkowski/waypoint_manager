class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def maintain_page_number
    params[:page] ||= 1
  end
end
