class User < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable
end
