# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Aside Navigator', type: :feature do
  let(:user) { create(:user, :admin, :confirmed) }

  # Here we put specific links for admin user
  # Other links are tested in user/navigator_spec.rb

  before do
    sign_in user
    visit user_root_path
  end

  it 'show admin links' do
    within('aside.navigator') do
      expect(page).to have_content(I18n.t('navigation.admin.title').upcase)
      expect(page).to have_link(I18n.t('navigation.admin.users'), href: admin_users_path)
      expect(page).to have_link(I18n.t('navigation.admin.roles'), href: admin_roles_path)
      expect(page).to have_link(I18n.t('navigation.admin.tiers'), href: admin_tiers_path)
    end
  end
end
