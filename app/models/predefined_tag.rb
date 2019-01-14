# Admin-curated list of tag presets available for the user to select from.
# Users can write in their own tags, but rather than fully crowdsourcing,
# we'd like to predefine some common ones.
class PredefinedTag < ApplicationRecord
  PRESETS = ["water / nature / agriculture", "mobility & energy", "food & drink", "health / lifestyle / wellbeing", "education & knowledge generation", "psychology & inner development", "culture & worldviews", "sharing & social movements", "business & organizational change", "politics & institutions", "law & order", "economy & jobs", "minorities & empowerment"]

  def self.repopulate
    self.delete_all
    PRESETS.each do |name|
      self.create!(name: name)
    end
  end

  validates :name, presence: true, length: {maximum: 50}
end
