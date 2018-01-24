module ControllerMacros
  include Warden::Test::Helpers

  def self.included(base)
    base.before(:each) { Warden.test_mode! }
    base.after(:each) { Warden.test_reset! }
  end

  def sign_in(resource)
    login_as(resource, scope: warden_scope(resource))
  end

  def sign_out(resource)
    logout(warden_scope(resource))
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in(FactoryBot.create(:user_with_approvers))
    end
  end

  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in(FactoryBot.create :admin)
    end
  end

  def login_reviewer
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in((FactoryBot.create :user_with_approvers).reviewers.first.approver)
    end
  end

  # for testing multiple reviewer flow
  def login_first_reviewer
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in((FactoryBot.create :user_two_reviewers).reviewers.first.approver)
    end
  end

  # for testing multiple reviewer flow
  def login_second_reviewer
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in((FactoryBot.create :user_two_reviewers).reviewers.second.approver)
    end
  end

  # for testing delegate flow
  def login_delegate
    before(:each) do
      u = create :complete_user_with_delegate
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in(u.delegates.first)
    end
  end

  private

  def warden_scope(resource)
    resource.class.name.underscore.to_sym
  end
end
