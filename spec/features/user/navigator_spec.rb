# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Aside Navigator', type: :feature do
  let(:user) { create(:user, :confirmed) }
  let(:menu_links) do
    {
      dashboard: { text: I18n.t('navigation.dashboard'), link: user_root_path },
      edit_profile: { text: I18n.t('navigation.profile.edit'), link: edit_user_registration_path },
      change_password: { text: I18n.t('navigation.profile.change_password'),
                         link: edit_user_registration_password_path },
      api_keys: { text: I18n.t('navigation.profile.api_keys'), link: users_api_keys_path },
      logout: { text: I18n.t('navigation.account.sign_out'), link: destroy_user_session_path }
    }
  end

  before do
    sign_in user
    visit user_root_path
  end

  it 'show menu links' do
    within('aside.navigator') do
      menu_links.each do |_k, v|
        expect(page).to have_link(v[:text], href: v[:link])
      end
    end
  end

  it 'do not show admin links' do
    within('aside.navigator') do
      expect(page).not_to have_content(I18n.t('navigation.admin.title').upcase)
      expect(page).not_to have_link(I18n.t('navigation.admin.users'), href: admin_users_path)
    end
  end
end
