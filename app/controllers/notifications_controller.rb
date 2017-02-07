class NotificationsController < ApplicationController
  before_action :require_login

  def index
    @notifications = current_user.notifications.order("created_at DESC").limit(50)
  end

  def show
    @notification = current_user.notifications.find(params[:id])
    @notification.update!(read: true)
    redirect_to url_for(@notification.target)
  end

  def mark_all_read
    current_user.notifications.where(read: false).update_all(read: true)
    redirect_to request.referer
  end
end