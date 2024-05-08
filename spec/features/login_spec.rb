# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User login', type: :feature do
  context 'when user is not signed in' do
    context 'when user not confirmed' do
      let(:user) { create(:user) }

      before do
        sign_in user
        visit root_path
      end

      it 'redirect to login path' do
        expect(current_path).to eq new_user_session_path
      end

      it 'show flash message saying that must confirm account' do
        expect(page).to have_css('.notices .notice__text', text: I18n.t('devise.failure.unconfirmed'))
      end
    end

    context 'when user is confirmed' do
      let(:user) { create(:user, :confirmed) }

      before do
        sign_in user
        visit root_path
      end

      it 'show root_path' do
        expect(current_path).to eq root_path
      end

      it 'show dashboard link in header' do
        expect(page).to have_css('.navbar a', text: 'Dashboard')
      end

      it 'can logout' do
        visit user_root_path
        within('aside.navigator') do
          click_on I18n.t('navigation.account.sign_out')
        end
        expect(current_path).to eq new_user_session_path
      end
    end
  end
end
