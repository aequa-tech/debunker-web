# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User change password', type: :feature do
  let(:user) { create(:user, :confirmed) }

  before do
    sign_in user
    visit edit_user_registration_password_path
  end

  it 'show change password form' do
    expect(page).to have_css('form.edit_user')
  end

  it 'show back to dashboard link' do
    expect(page).to have_link(I18n.t('users.api_keys.back_to_dashboard'),
                              href: user_root_path)
  end

  it 'can change password' do
    new_password = 'new_password'
    fill_in 'user_password', with: new_password
    fill_in 'user_password_confirmation', with: new_password
    fill_in 'user_current_password', with: user.password
    click_on I18n.t('devise.passwords.edit.submit')
    expect(page).to have_content(I18n.t('devise.registrations.updated'))
  end

  it 'update account because no password change' do
    fill_in 'user_password', with: ''
    fill_in 'user_password_confirmation', with: ''
    fill_in 'user_current_password', with: user.password
    click_on I18n.t('devise.passwords.edit.submit')
    expect(page).to have_content(I18n.t('devise.registrations.updated'))
  end

  it 'show error message when current password is wrong' do
    fill_in 'user_password', with: 'new_password'
    fill_in 'user_password_confirmation', with: 'new_password'
    fill_in 'user_current_password', with: 'wrong_password'
    click_on I18n.t('devise.passwords.edit.submit')
    expect(page).to have_content(I18n.t('activerecord.errors.models.user.attributes.current_password.invalid'))
  end

  it 'show error if password confirmation do not match' do
    fill_in 'user_password', with: 'new_password'
    fill_in 'user_password_confirmation', with: 'wrong_password'
    fill_in 'user_current_password', with: user.password
    click_on I18n.t('devise.passwords.edit.submit')
    expect(page).to have_content(I18n.t('activerecord.errors.models.user.attributes.password_confirmation.confirmation'))
  end
end
