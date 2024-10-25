# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User API keys', type: :feature do
  let(:user) { create(:user, :confirmed) }

  before do
    sign_in user
    visit users_api_keys_path
  end

  context 'when user has no data about api_keys' do
    before do
      user.api_keys.destroy_all
      visit users_api_keys_path
    end

    it 'show empty state' do
      expect(page).to have_content(I18n.t('empty_state.title'))
      expect(page).to have_content(I18n.t('users.api_keys.empty_state'))
    end

    it 'show create api_key form/button' do
      expect(page).to have_css("form[action='#{users_api_keys_path}'][method='post']")
      within('form') do
        expect(page).to have_button(I18n.t('users.api_keys.create'), type: 'submit')
      end
    end

    context 'when user create api_key' do
      before do
        click_on I18n.t('users.api_keys.create')
      end

      it 'show api_key created success message' do
        expect(page).to have_content(I18n.t('users.api_keys.notices.created'))
      end

      it 'show api_key data' do
        within('.top-resume--api-key.top-resume--success') do
          expect(page).to have_content(user.api_keys.active.last.access_token)
          expect(page).to have_content(JWT.decode(user.api_keys.active.last.secret_token,
                                                  ApiKey.usk(user.api_keys.active.last.access_token, user)).first)
        end
      end

      it 'show api_key warning' do
        within('.top-resume--api-key.top-resume--success') do
          expect(page).to have_content(I18n.t('users.api_keys.just_created_warning'))
        end
      end

      it 'show back to dashboard link' do
        expect(page).to have_link(I18n.t('users.api_keys.back_to_dashboard'),
                                  href: user_root_path)
      end

      it 'show api_key in table' do
        user.reload
        visit users_api_keys_path
        within('table') do
          expect(page).to have_text(user.api_keys.last.access_token)
          expect(page).to have_text(user.api_keys.last.masked_secret)
          expect(page).to have_css("a[href='#{users_api_key_path(user.api_keys.last)}'][data-turbo-method='delete']")
        end
      end
    end
  end

  context 'when user has api_keys datas' do
    let!(:api_key_expired) { create(:api_key, user:, expired_at: Time.current) }
    let!(:api_key) { create(:api_key, user:) }

    before do
      user.reload
      visit users_api_keys_path
    end

    it 'show top-resume with active api_keys' do
      within('.api-keys-container') do
        user.api_keys.active.each do |api_key|
          expect(page).to have_text(api_key.access_token)
          expect(page).to have_text(api_key.masked_secret)
          expect(page).to have_text(api_key.available_tokens.count.to_s)
          expect(page).to have_text(I18n.t('users.api_keys.available_tokens'))
        end
      end
    end

    it 'do not show expired api_keys in top resume' do
      within('.api-keys-container') do
        expect(page).not_to have_text(api_key_expired.access_token)
      end
    end

    it 'show api_keys in table' do
      within('table') do
        user.api_keys.each do |api_key|
          expect(page).to have_text(api_key.access_token)
          expect(page).to have_text(api_key.masked_secret)

          if api_key.expired?
            expect(page).to have_text(ApiKey.human_attribute_name(:expired_at))
            expect(page).to have_text(I18n.l(api_key.expired_at, format: :short))
          else
            expect(page).to have_css("a[href='#{users_api_key_path(api_key)}'][data-turbo-method='delete']")
          end
        end
      end
    end

    it 'show pagination' do
      expect(page).to have_css('nav.pagy.nav')
    end

    it 'show create new api_key button' do
      expect(page).to have_css("form[action='#{users_api_keys_path}'][method='post']")
      within('form') do
        expect(page).to have_button(I18n.t('users.api_keys.create'), type: 'submit')
      end
    end

    context 'when user create api_key' do
      before do
        click_on I18n.t('users.api_keys.create')
      end

      it 'show api_key created success message' do
        expect(page).to have_content(I18n.t('users.api_keys.notices.created'))
      end

      it 'show api_key data' do
        within('.top-resume--api-key.top-resume--success') do
          expect(page).to have_content(user.api_keys.last.access_token)
          expect(page).to have_content(JWT.decode(user.api_keys.last.secret_token,
                                                  ApiKey.usk(user.api_keys.last.access_token, user)).first)
        end
      end

      it 'show api_key warning' do
        within('.top-resume--api-key.top-resume--success') do
          expect(page).to have_content(I18n.t('users.api_keys.just_created_warning'))
        end
      end

      it 'show back to dashboard link' do
        expect(page).to have_link(I18n.t('users.api_keys.back_to_dashboard'),
                                  href: user_root_path)
      end

      it 'show api_key in table' do
        visit users_api_keys_path
        within('table') do
          expect(page).to have_text(user.api_keys.last.access_token)
          expect(page).to have_text(user.api_keys.last.masked_secret)
          expect(page).to have_css("a[href='#{users_api_key_path(user.api_keys.last)}'][data-turbo-method='delete']")
        end
      end

      it 'only one api_key is active' do
        expect(user.api_keys.active.count).to eq(1)
        visit users_api_keys_path
        click_on I18n.t('users.api_keys.create')
        user.reload
        expect(user.api_keys.active.count).to eq(1)
      end
    end

    context 'when user revoke api_key' do
      before do
        accept_confirm do
          find("a[href='#{users_api_key_path(api_key)}'][data-turbo-method='delete']").click
        end
        sleep 0.5
      end

      it 'show api_key deleted success message' do
        expect(page).to have_content(I18n.t('users.api_keys.notices.expired'))
      end

      it 'do not show api_key in table' do
        api_key.reload
        within('table') do
          expect(page).to have_text(api_key.access_token)
          expect(page).to have_text(api_key.masked_secret)
          expect(page).not_to have_css("a[href='#{users_api_key_path(api_key)}'][data-turbo-method='delete']")
          expect(page).to have_text(ApiKey.human_attribute_name(:expired_at))
          expect(page).to have_text(I18n.l(api_key.expired_at, format: :short))
        end
      end
    end
  end
end
