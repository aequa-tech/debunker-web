# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Admin roles', type: :feature do
  let!(:admin) { create(:user, :admin, :confirmed) }
  let!(:user) { create(:user, :with_api_key) }
  let!(:role) { create(:role, name: 'Test role', role_type: 'user') }
  let!(:role2) { create(:role, name: 'Another role', role_type: 'admin') }

  before do
    sign_in admin
    visit admin_roles_path
  end

  it 'show roles list' do
    within('table') do
      Role.all.each do |role|
        expect(page).to have_content(role.name)
        expect(page).to have_content(role.role_type)
        expect(page).to have_content(role.tier.name)
        expect(page).to have_content("#{role.tier.tokens_rate} #{Token.model_name.human(count: 2)} / #{role.tier.reload_rate_amount} #{I18n.t("time.#{role.tier.reload_rate_unit}")}")
        expect(page).to have_content(I18n.l(role.created_at, format: :short))
        expect(page).to have_content(I18n.l(role.updated_at, format: :short))
      end
    end
  end

  it 'show pagination' do
    expect(page).to have_css('nav.pagy.nav')
  end
end
