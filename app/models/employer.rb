class Employer < ApplicationRecord
  has_many :job_offers

  validates :name, :code, presence: true, uniqueness: true

  acts_as_nested_set counter_cache: :children_count

  def name_with_code
    "#{name} (#{code})"
  end
end
