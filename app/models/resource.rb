class Resource < ActiveRecord::Base
  DEFAULT_MEDIA_TYPES = ['video', 'lecture', 'audio', 'image', 'book', 'research article', 'in press', 'unpublished', 'essay', 'popular media', 'brochure', 'website', 'course']

  acts_as_taggable_on :tags
  acts_as_taggable_on :media_types

  belongs_to :creator, class_name: :User
  belongs_to :target, polymorphic: true
  has_many :received_like_flags, as: :target

  validates :title, presence: true
  validates :url, presence: true
  validate :require_ownership_if_uploaded

  has_attached_file :attachment
  validates_attachment :attachment, size: { in: 0..10.megabytes }
  do_not_validate_attachment_file_type :attachment

  private

  def require_ownership_if_uploaded
    if attachment.present? and ! ownership_affirmed?
      errors.add(:attachment, "You must verify that you own this file.")
    end
  end
end
