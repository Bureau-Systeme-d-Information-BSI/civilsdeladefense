class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_many :job_applications

  has_one_attached :photo
  validates :photo, file_size: { less_than_or_equal_to: 1.megabytes },
                    file_content_type: { allow: ['image/jpg', 'image/jpeg', 'image/png'] },
                    if: -> { photo.attached? }

  def full_name
    [first_name, last_name].join(" ")
  end
end
