# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Dashboard', type: :feature do
  let(:user) { create(:user) }

  before do
    sign_in user
    visit root_path
  end

  it 'shows the user dashboard' do
    debugger
    expect(page).to have_content('Dashboard')
  end

  it 'shows the user name' do
    expect(page).to have_content(user.name)
  end

  it 'shows the user email' do
    expect(page).to have_content(user.email)
  end

  it 'shows the user role' do
    expect(page).to have_content(user.role)
  end

  it 'shows the user created at' do
    expect(page).to have_content(user.created_at)
  end

  it 'shows the user updated at' do
    expect(page).to have_content(user.updated_at)
  end

  it 'shows the user edit link' do
    expect(page).to have_link('Edit', href: edit_user_registration_path)
  end

  it 'shows the user sign out link' do
    expect(page).to have_link('Sign out', href: destroy_user_session_path)
  end
end
