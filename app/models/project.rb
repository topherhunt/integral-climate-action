class Project < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  __elasticsearch__.index_name("ic-#{Rails.env}-projects")

  STAGES = ["idea", "developing", "< 1 year", "1-5 years", "5-10 years", "> 10 years"]

  belongs_to :owner, class_name: 'User'
  has_many :resources, as: :target
  has_many :received_like_flags, class_name: 'LikeFlag', as: :target
  has_many :received_stay_informed_flags, class_name: 'StayInformedFlag', as: :target
  has_many :received_get_involved_flags, class_name: 'GetInvolvedFlag', as: :target

  scope :latest, ->(n) { order("created_at DESC").limit(n) }

  # See https://github.com/mbleigh/acts-as-taggable-on#usage
  acts_as_taggable_on :tags

  validates :owner, presence: true
  validates :title, presence: true, length: {maximum: 100}
  validates :subtitle, presence: true, length: {maximum: 255}
  validates :partners, length: {maximum: 500}
  validates :video_url, length: {maximum: 255}
  validate :video_url_is_youtube
  validates :image_file_name, presence: true, length: {maximum: 255}
  validates :desired_impact, presence: true, length: {maximum: 500}
  validates :contribution_to_world, presence: true, length: {maximum: 500}
  validates :location_of_home, presence: true, length: {maximum: 100}
  validates :location_of_impact, presence: true, length: {maximum: 100}
  validates :stage, presence: true, inclusion: { in: STAGES }
  validates :help_needed, length: {maximum: 500}
  validates :q_background, length: {maximum: 500}
  validates :q_meaning, length: {maximum: 500}
  validates :q_community, length: {maximum: 500}
  validates :q_goals, length: {maximum: 500}
  validates :q_how_make_impact, length: {maximum: 500}
  validates :q_how_measure_impact, length: {maximum: 500}
  validates :q_potential_barriers, length: {maximum: 500}
  validates :q_project_assets, length: {maximum: 500}
  validates :q_larger_vision, length: {maximum: 500}

  # See https://github.com/thoughtbot/paperclip#quick-start
  has_attached_file :image, styles: { medium: "300x300#", thumb: "100x100#" },
    default_url: "/missing_project.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  def self.most_popular(n)
    # TODO: This triggers N+1 queries.
    # More efficient approaches to this, for consideration in the long run:
    # - Store result in the Rails cache so it doesn't need to be recomputed each time
    # - Custom SQL query on the like_flags table to get the most liked project_id
    # - Add received_like_flags_count cache column so we can sort by that
    all.sort_by{ |p| -p.received_like_flags.count }.take(n)
  end

  def as_indexed_json(options={}) # ElasticSearch integration
    {
      title: title,
      subtitle: subtitle,
      introduction: introduction,
      stage: stage,
      location: location,
      owner: owner.full_name,
      tags: tag_list.join(", "),
      visible: true
    }
  end

  def video_url_is_youtube
    if video_url and !video_url.match(/youtube\.com|youtu\.be/)
      errors.add(:video_url, "must be a YouTube video URL (for now)")
    end
  end

  def involved_users
    # TODO: This triggers N+1 queries.
    user_ids = [
      owner_id,
      received_like_flags.pluck(:user_id),
      received_stay_informed_flags.pluck(:user_id),
      received_get_involved_flags.pluck(:user_id)
    ].flatten.uniq
    User.where(id: user_ids)
  end
end
