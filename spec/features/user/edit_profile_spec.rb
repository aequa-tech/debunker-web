# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User edit profile', type: :feature do
  let(:user) { create(:user, :confirmed) }

  before do
    sign_in user
    visit edit_user_registration_path
  end

  it 'show edit profile form' do
    expect(page).to have_css('form.edit_user')
  end

  it 'show delete account link' do
    expect(page).to have_text(I18n.t('devise.links.unhappy_with_your_account'))
    expect(page).to have_link(I18n.t('devise.links.cancel_account'))
    expect(page).to have_css("a[href='#{user_registration_path}'][data-turbo-method='delete']")
  end

  it 'show back to dashboard link' do
    expect(page).to have_link(I18n.t('users.api_keys.back_to_dashboard'),
                              href: user_root_path)
  end

  it 'can change user name' do
    new_name = 'New Name'
    fill_in 'user_first_name', with: new_name
    click_on I18n.t('devise.registrations.edit.update')
    expect(page).to have_content(I18n.t('devise.registrations.updated'))
    expect(page).to have_content(new_name.upcase)
  end

  it 'can change surname' do
    new_name = 'New Surname'
    fill_in 'user_last_name', with: new_name
    click_on I18n.t('devise.registrations.edit.update')
    expect(page).to have_content(I18n.t('devise.registrations.updated'))
    expect(page).to have_content(new_name.upcase)
  end

  it 'show error message when first name is blank' do
    fill_in 'user_first_name', with: ''
    click_on I18n.t('devise.registrations.edit.update')
    expect(page).to have_content("#{User.human_attribute_name(:first_name)} #{I18n.t('activerecord.errors.models.user.attributes.first_name.blank')}")
  end

  it 'show error message when last name is blank' do
    fill_in 'user_last_name', with: ''
    click_on I18n.t('devise.registrations.edit.update')
    expect(page).to have_content("#{User.human_attribute_name(:last_name)} #{I18n.t('activerecord.errors.models.user.attributes.last_name.blank')}")
  end

  context 'when user cancel account' do
    before do
      accept_confirm do
        click_on I18n.t('devise.links.cancel_account')
      end
      sleep 0.5
    end

    it 'redirect to login page' do
      expect(page).to have_current_path(root_path)
    end

    it 'show flash message saying that account was successfully cancelled' do
      expect(page).to have_content(I18n.t('devise.registrations.destroyed'))
    end

    it 'cannot login with old credentials' do
      visit new_user_session_path
      within('form') do
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
        click_on I18n.t('devise.sessions.new.submit')
      end
      expect(page).to have_content(I18n.t('devise.failure.invalid', authentication_keys: 'email').humanize)
    end
  end
end
