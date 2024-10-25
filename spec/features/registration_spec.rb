# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User registration', type: :feature do
  it 'sign up button is shown in header' do
    visit root_path
    within('.navbar') do
      expect(page).to have_link(I18n.t('devise.links.sign_up'), href: new_user_registration_path)
    end
  end

  it 'sign up form is shown' do
    visit new_user_registration_path
    expect(page).to have_css('form#new_user')
  end

  context 'when user sign up' do
    let(:user) { build(:user) }

    context 'with valid data' do
      before do
        visit new_user_registration_path

        within('form') do
          fill_in 'user_first_name', with: user.first_name
          fill_in 'user_last_name', with: user.first_name
          fill_in 'user_email', with: user.email
          fill_in 'user_password', with: user.password
          fill_in 'user_password_confirmation', with: user.password
          click_on I18n.t('devise.links.sign_up')
        end
      end

      it 'redirect to root path' do
        expect(page).to have_current_path(root_path)
      end

      it 'show flash message saying that confirmation email was sent' do
        expect(page).to have_css('.notices .notice__text', text: I18n.t('devise.registrations.signed_up_but_unconfirmed'))
      end

      it 'send confirmation email' do
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        email = ActionMailer::Base.deliveries.last
        expect(email.to).to eq([user.email])
        expect(email.subject).to eq(I18n.t('devise.mailer.confirmation_instructions.subject'))
        expect(email.body).to include(I18n.t('devise.mailer.confirmation_instructions.greeting', email: user.email))
        expect(email.body).to include(I18n.t('devise.mailer.confirmation_instructions.instructions'))
        expect(email.body).to include(I18n.t('devise.mailer.confirmation_instructions.link'))
        expect(email.body).to include(user_confirmation_url(confirmation_token: User.last.confirmation_token))
      end

      it 'visiting confirmation link confirm user' do
        visit user_confirmation_path(confirmation_token: User.last.confirmation_token)
        expect(page).to have_content(I18n.t('devise.confirmations.confirmed'))

        user = User.last
        expect(user.confirmed?).to be_truthy
      end
    end

    context 'with invalid data' do
      before do
        visit new_user_registration_path

        within('form') do
          fill_in 'user_first_name', with: user.first_name
          fill_in 'user_last_name', with: user.last_name
          fill_in 'user_email', with: user.email
          fill_in 'user_password', with: user.password
          fill_in 'user_password_confirmation', with: user.password
        end
      end

      it 'fail with blank name' do
        fill_in 'user_first_name', with: ''
        within('form') { click_on I18n.t('devise.links.sign_up') }

        expect(page).to have_css('.notices .notice__text', text: "#{User.human_attribute_name(:first_name)} #{I18n.t('activerecord.errors.models.user.attributes.first_name.blank')}")
      end

      it 'fail with blank surname' do
        fill_in 'user_last_name', with: ''
        within('form') { click_on I18n.t('devise.links.sign_up') }

        expect(page).to have_css('.notices .notice__text', text: "#{User.human_attribute_name(:last_name)} #{I18n.t('activerecord.errors.models.user.attributes.last_name.blank')}")
      end

      it 'fail with blank email' do
        fill_in 'user_email', with: ''
        within('form') { click_on I18n.t('devise.links.sign_up') }

        expect(page).to have_css('.notices .notice__text', text: "#{User.human_attribute_name(:email)} #{I18n.t('activerecord.errors.models.user.attributes.email.blank')}")
      end

      it 'fail with blank password' do
        fill_in 'user_password', with: ''
        within('form') { click_on I18n.t('devise.links.sign_up') }

        expect(page).to have_css('.notices .notice__text', text: "#{User.human_attribute_name(:password)} #{I18n.t('activerecord.errors.models.user.attributes.password.blank')}")
      end

      it 'fail with password too short' do
        fill_in 'user_password', with: '123'
        within('form') { click_on I18n.t('devise.links.sign_up') }

        expect(page).to have_css('.notices .notice__text', text: "#{User.human_attribute_name(:password)} #{I18n.t('activerecord.errors.models.user.attributes.password.too_short', count: Devise.password_length.min)}")
      end

      it 'fail with password too weak' do
        fill_in 'user_password', with: 'test1234'
        within('form') { click_on I18n.t('devise.links.sign_up') }

        expect(page).to have_css('.notices .notice__text', text: "#{User.human_attribute_name(:password)} #{I18n.t('activerecord.errors.models.user.attributes.password.too_weak', count: Devise.password_length.min)}")
      end

      it 'fail with blank password confirmation' do
        fill_in 'user_password_confirmation', with: ''
        within('form') { click_on I18n.t('devise.links.sign_up') }

        expect(page).to have_css('.notices .notice__text', text: "#{User.human_attribute_name(:password_confirmation)} #{I18n.t('activerecord.errors.models.user.attributes.password_confirmation.confirmation')}")
      end

      it 'fail with password confirmation different from password' do
        fill_in 'user_password_confirmation', with: 'different'
        within('form') { click_on I18n.t('devise.links.sign_up') }

        expect(page).to have_css('.notices .notice__text', text: "#{User.human_attribute_name(:password_confirmation)} #{I18n.t('activerecord.errors.models.user.attributes.password_confirmation.confirmation')}")
      end

      it 'does not send confirmation email' do
        fill_in 'user_first_name', with: ''
        within('form') { click_on I18n.t('devise.links.sign_up') }

        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end
  end
end
