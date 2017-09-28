# Generated via
#  `rails generate hyrax:work Article`
require 'rails_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create a Article', js: true do
  context 'a logged in user' do
    let(:user_attributes) do
      { email: 'test@example.com' }
    end
    let(:user) do
      User.new(user_attributes) { |u| u.save(validate: false) }
    end

    before do
      AdminSet.find_or_create_default_admin_set_id
      login_as user
    end

    scenario do
      visit '/dashboard'
      Capybara::Maleficent.with_sleep_injection(handled_exceptions: [Capybara::ExpectationNotMet]) do
        click_link "Works"
      end
      Capybara::Maleficent.with_sleep_injection(handled_exceptions: [Capybara::ExpectationNotMet]) do
        click_link "Add new work"
      end

      # If you generate more than one work uncomment these lines
      choose "payload_concern", option: "Article"
      Capybara::Maleficent.with_sleep_injection(handled_exceptions: [Capybara::ExpectationNotMet]) do
        click_button "Create work"
      end

      page.assert_text "Add New Article"
    end
  end
end
