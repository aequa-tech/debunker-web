# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User login', type: :feature do
  context 'when user is not signed in' do
    context 'when user not confirmed' do
      let(:user) { create(:user) }

      context 'with logged in user' do
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

      context 'whitout logged in user' do
        before do
          visit root_path
        end

        context 'when user insert email and password' do
          before do
            within('.navbar') do
              click_on I18n.t('devise.links.sign_in')
            end

            within('form') do
              fill_in 'user_email', with: user.email
              fill_in 'user_password', with: user.password
              click_on I18n.t('devise.links.sign_in')
            end
          end

          it 'show flash message saying that must confirm account' do
            expect(page).to have_css('.notices .notice__text', text: I18n.t('devise.failure.unconfirmed'))
          end
        end
      end
    end

    context 'when user is confirmed' do
      let(:user) { create(:user, :confirmed) }

      context 'with logged in user' do
        before do
          sign_in user
          visit root_path
        end

        it 'show root_path' do
          expect(current_path).to eq root_path
        end

        it 'show dashboard link in header' do
          expect(page).to have_css('.navbar a', text: I18n.t('navigation.dashboard'))
        end

        it 'can logout' do
          visit user_root_path
          within('aside.navigator') do
            click_on I18n.t('navigation.account.sign_out')
          end
          expect(current_path).to eq new_user_session_path
        end
      end

      context 'whitout logged in user' do
        before do
          visit root_path
        end

        context 'when user insert email and password' do
          before do
            within('.navbar') do
              click_on I18n.t('devise.links.sign_in')
            end

            within('form') do
              fill_in 'user_email', with: user.email
              fill_in 'user_password', with: user.password
              click_on I18n.t('devise.links.sign_in')
            end
          end

          it 'show root_path' do
            expect(current_path).to eq user_root_path
          end

          it 'show notice message' do
            expect(page).to have_css('.notices .notice__text', text: I18n.t('devise.sessions.signed_in'))
          end

          it 'show dashboard link in header' do
            expect(page).to have_content(user.email)
          end
        end
      end
    end
  end
end
