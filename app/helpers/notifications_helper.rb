module NotificationsHelper
  def unread_notifications_count
    @unread_notifications_count ||= current_user.notifications.unread.count
  end

  def my_recent_notifications
    current_user.notifications.order("created_at DESC").limit(10)
  end
end
