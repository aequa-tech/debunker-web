# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Dashboard', type: :feature do
  context 'when user is not signed in' do
    it 'visiting dashboard redirect to login path' do
      visit user_root_path
      expect(current_path).to eq new_user_session_path
    end

    context 'when user is logged in' do
      let(:user) { create(:user, :confirmed) }

      before do
        sign_in user
        visit root_path
      end

      it 'click in dashboard link redirect to dashboard' do
        click_on 'Dashboard'
        sleep 0.3
        expect(current_path).to eq user_root_path
      end

      it 'visiting dashboard show dashboard' do
        visit user_root_path
        expect(current_path).to eq user_root_path
      end

      it 'show user-info' do
        visit user_root_path
        within('.top-resume--user-info') do
          expect(page).to have_text(user.first_name.upcase)
          expect(page).to have_text(user.email)
        end
      end

      context 'without api_keys' do
        before do
          user.api_keys.destroy_all
        end

        it 'show info about no api_keys' do
          visit user_root_path
          within('.api-keys-container') do
            expect(page).to have_text(I18n.t('users.api_keys.no_current'))
          end
        end
      end

      context 'with api_keys' do
        let(:api_key) { create(:api_key, user:) }
        let(:api_key2) { create(:api_key, user:) }

        it 'show api_keys info' do
          user.reload

          visit user_root_path
          within('.api-keys-container') do
            user.api_keys.active.each do |api_key|
              expect(page).to have_text(api_key.access_token)
              expect(page).to have_text(api_key.masked_secret)
              expect(page).to have_text(api_key.available_tokens.count.to_s)
              expect(page).to have_text(I18n.t('users.api_keys.available_tokens'))
            end
          end
        end
      end
    end
  end
end
