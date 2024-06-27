# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Admin edit users', type: :feature do
  let!(:admin) { create(:user, :admin, :confirmed) }
  let!(:user) { create(:user, :with_api_key) }

  before do
    sign_in admin
    visit admin_users_path
  end

  it 'show users list' do
    within('table') do
      User.all.each do |user|
        expect(page).to have_content(user.email)
        expect(page).to have_content(I18n.l(user.created_at, format: :short))
        expect(page).to have_content(I18n.l(user.updated_at, format: :short))
        expect(page).to have_link(nil, href: edit_admin_user_path(user))
      end
    end
  end

  it 'show pagination' do
    expect(page).to have_css('nav.pagy.nav')
  end

  it 'show delete link if the user in not logged user' do
    within('table') do
      expect(page).to have_css("a[href='#{admin_user_path(user)}'][data-turbo-method='delete']")
    end
  end

  it 'do not show delete link if the user is logged user' do
    within('table') do
      expect(page).not_to have_css("a[href='#{admin_user_path(admin)}'][data-turbo-method='delete']")
    end
  end

  context 'when delete user' do
    it 'can delete user' do
      within('table') do
        accept_confirm do
          find("a[href='#{admin_user_path(user)}'][data-turbo-method='delete']").click
        end
      end
      expect(page).to have_content(I18n.t('admin.users.notices.deleted'))
    end

    it 'deleted user is not in the list' do
      within('table') do
        accept_confirm do
          find("a[href='#{admin_user_path(user)}'][data-turbo-method='delete']").click
        end
        expect(page).not_to have_content(user.email)
      end
    end
  end

  context 'when edit user' do
    before do
      within('table') do
        find("a[href='#{edit_admin_user_path(user)}']").click
      end
    end

    it 'show user top resume info' do
      within('.top-resume--user-info') do
        expect(page).to have_content(user.name.upcase)
        expect(page).to have_content(user.email)
      end
    end

    it 'show user form' do
      expect(page).to have_css("form[action='#{admin_user_path(user)}'][method='post']")
    end

    it 'can change user role' do
      select('Admin', from: 'user_role_id')
      click_on(I18n.t('admin.users.edit.update'))
      expect(page).to have_content(I18n.t('admin.users.notices.updated'))

      user.reload
      expect(user.role.name).to eq('Admin')
    end

    it 'show user api_keys with editable available tokens in form' do
      within('form') do
        user.api_keys.active.each_with_index do |api_key, index|
          expect(page).to have_content(api_key.access_token)
          expect(page).to have_css("input[name='user[api_keys_attributes][#{index}][available_tokens_number]']")
          expect(page).to have_css("a[data-turbo-method='delete'][href='#{revoke_api_key_admin_user_path(user, api_key)}']")
        end
      end
    end

    it 'can change user api_keys available tokens' do
      within('form') do
        user.api_keys.active.each_with_index do |_api_key, index|
          fill_in("user[api_keys_attributes][#{index}][available_tokens_number]", with: 15)
        end
        click_on(I18n.t('admin.users.edit.update'))
      end

      expect(page).to have_content(I18n.t('admin.users.notices.updated'))
      user.reload
      user.api_keys.active.each do |api_key|
        expect(api_key.available_tokens.count).to eq(15)
      end
    end

    it 'can revoke user api_keys' do
      within('form') do
        accept_confirm do
          find("a[data-turbo-method='delete'][href='#{revoke_api_key_admin_user_path(user, user.api_keys.last)}']").click
        end
      end

      expect(page).to have_content(I18n.t('admin.users.notices.api_key_revoked'))
      user.reload
      expect(user.api_keys.active.count).to eq(0)
    end
  end
end
