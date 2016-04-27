class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable, :confirmable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # See https://github.com/mbleigh/acts-as-taggable-on#usage
  acts_as_taggable_on :skills
  acts_as_taggable_on :passions
  acts_as_taggable_on :traits

  # See https://github.com/thoughtbot/paperclip#quick-start
  has_attached_file :image, styles: { medium: "300x300#", thumb: "100x100#" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  has_many :created_resources, class_name: :Resource, foreign_key: :creator_id, inverse_of: :creator

  validates :dream_of_future_where, length: { maximum: 255 }

  def name
    "#{first_name} #{last_name}"
  end
end
