# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Admin tiers', type: :feature do
  let!(:admin) { create(:user, :admin, :confirmed) }
  let!(:user) { create(:user, :with_api_key) }
  let!(:tier) { create(:tier, name: 'Tier test', tokens_rate: 99, reload_rate_amount: 2, reload_rate_unit: 'week') }
  let!(:tier2) { create(:tier, name: 'Another tier', tokens_rate: 2, reload_rate_amount: 1, reload_rate_unit: 'month') }

  before do
    sign_in admin
    visit admin_tiers_path
  end

  it 'show tiers list' do
    within('table') do
      Tier.all.each do |tier|
        expect(page).to have_content(tier.name)
        expect(page).to have_content(tier.tokens_rate)
        expect(page).to have_content("#{tier.reload_rate_amount} #{I18n.t("time.#{tier.reload_rate_unit}")}")
        expect(page).to have_content(I18n.l(tier.created_at, format: :short))
        expect(page).to have_content(I18n.l(tier.updated_at, format: :short))
      end
    end
  end

  it 'show pagination' do
    expect(page).to have_css('nav.pagy.nav')
  end
end
