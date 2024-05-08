# frozen_string_literal: true

require 'capybara/rails'
require 'capybara/rspec'

RSpec.configure do |config|
  config.before(:each, type: :feature) do
    Capybara.current_driver = ENV.fetch('SHOW_BROWSER', 'false') == 'true' ? :selenium : :selenium_headless
  end
end
