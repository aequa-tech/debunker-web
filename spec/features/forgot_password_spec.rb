# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Forgot password', type: :feature do
  let(:user) { create(:user, :confirmed) }

  it 'forgot password link is shown in login form' do
    visit new_user_session_path
    expect(page).to have_link(I18n.t('devise.links.forgot_your_password'), href: new_user_password_path)
  end

  it 'forgot password form is shown' do
    visit new_user_password_path
    expect(page).to have_css('form#new_user')
  end

  it 'show sent mail notice laso with bad user' do
    visit new_user_password_path

    within('form') do
      fill_in 'user_email', with: 'invalid@email.com'
      click_on I18n.t('devise.passwords.new.send_instructions')
    end

    expect(page).to have_css('.notices .notice__text', text: I18n.t('devise.passwords.send_paranoid_instructions'))
    expect(ActionMailer::Base.deliveries.count).to eq(0)
  end

  context 'when user forgot password' do
    before do
      ActionMailer::Base.deliveries.clear
      visit new_user_password_path

      within('form') do
        fill_in 'user_email', with: user.email
        click_on I18n.t('devise.passwords.new.send_instructions')
      end
    end

    it 'send reset password instructions notice' do
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_css('.notices .notice__text', text: I18n.t('devise.passwords.send_paranoid_instructions'))
    end

    it 'send reset password instructions email' do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq([user.email])
      expect(email.subject).to eq(I18n.t('devise.mailer.reset_password_instructions.subject'))
      expect(email.body).to include(I18n.t('devise.mailer.reset_password_instructions.greeting', email: user.email))
      expect(email.body).to include(I18n.t('devise.mailer.reset_password_instructions.instructions'))
      expect(email.body).to include(I18n.t('devise.mailer.reset_password_instructions.link'))
      expect(email.body).to include(edit_user_password_url(reset_password_token: ''))
      expect(email.body).to include(I18n.t('devise.mailer.reset_password_instructions.after_link'))
    end

    context 'visiting reset password link' do
      before do
        visit new_user_password_path

        within('form') do
          fill_in 'user_email', with: user.email
          click_on I18n.t('devise.passwords.new.send_instructions')
        end

        reset_password_token = ActionMailer::Base.deliveries.last.body.match(/reset_password_token=(.+)"/)[1]
        visit edit_user_password_path(reset_password_token:)
      end

      it 'show reset password form' do
        expect(page).to have_css('form#new_user')
      end

      context 'with valid data' do
        context 'when user reset password' do
          before do
            within('form') do
              fill_in 'user_password', with: 'new_password'
              fill_in 'user_password_confirmation', with: 'new_password'
              click_on I18n.t('devise.passwords.edit.change')
            end
          end

          it 'show flash message saying that password was changed' do
            expect(page).to have_current_path(user_root_path)
            expect(page).to have_css('.notices .notice__text', text: I18n.t('devise.passwords.updated'))
          end

          it 'user can login with new password' do
            sign_out user
            visit new_user_session_path

            within('form') do
              fill_in 'user_email', with: user.email
              fill_in 'user_password', with: 'new_password'
              click_on I18n.t('devise.links.sign_in')
            end

            expect(page).to have_current_path(user_root_path)
          end
        end
      end

      context 'with invalid data' do
        before do
          within('form') do
            fill_in 'user_password', with: 'new_password'
            fill_in 'user_password_confirmation', with: 'new_password'
          end
        end

        it 'fails with blank password' do
          within('form') do
            fill_in 'user_password', with: ''
            click_on I18n.t('devise.passwords.edit.change')
          end

          expect(page).to have_css('.notices .notice__text', text: "#{User.human_attribute_name(:password)} #{I18n.t('activerecord.errors.models.user.attributes.password.blank')}")
        end

        it 'fails with blank password confirmation' do
          within('form') do
            fill_in 'user_password_confirmation', with: ''
            click_on I18n.t('devise.passwords.edit.change')
          end

          expect(page).to have_css('.notices .notice__text', text: "#{User.human_attribute_name(:password_confirmation)} #{I18n.t('activerecord.errors.models.user.attributes.password_confirmation.confirmation')}")
        end

        it 'fails with password confirmation different from password' do
          within('form') do
            fill_in 'user_password_confirmation', with: 'different'
            click_on I18n.t('devise.passwords.edit.change')
          end

          expect(page).to have_css('.notices .notice__text', text: "#{User.human_attribute_name(:password_confirmation)} #{I18n.t('activerecord.errors.models.user.attributes.password_confirmation.confirmation')}")
        end
      end
    end
  end
end
