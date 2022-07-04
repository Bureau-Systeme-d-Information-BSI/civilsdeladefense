# frozen_string_literal: true

# Controller auth rspec macros
module ControllerMacros
  def login_admin
    before do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      admin = FactoryBot.create(:administrator)
      admin.confirm
      sign_in admin
    end
  end

  def login_employer
    before do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      employer = FactoryBot.create(:employer)
      admin = FactoryBot.create(:administrator, role: :employer, employer: employer)
      admin.confirm
      sign_in admin
    end
  end

  def login_grand_employer
    before do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      admin = FactoryBot.create(:administrator, role: nil)
      admin.confirm
      sign_in admin
    end
  end
  alias_method :login_cmg, :login_grand_employer

  def login_user
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @logged_user = FactoryBot.create(:user)
      @logged_user.confirm
      sign_in @logged_user
    end
  end
end
