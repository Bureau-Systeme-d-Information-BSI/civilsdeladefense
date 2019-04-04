class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_many :job_applications, dependent: :destroy

  mount_uploader :photo, PhotoUploader, mount_on: :photo_file_name
  validates :photo,
    file_size: { less_than: 1.megabytes },
    file_content_type: { allow: /^image\/.*/ }

  validate :password_complexity

  after_save :compute_job_applications_notifications_counter

  def compute_job_applications_notifications_counter
    job_applications.each &:compute_notifications_counter!
  end

  def full_name
    [first_name, last_name].join(" ")
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/

    errors.add :password, :not_strong_enough
  end
end
