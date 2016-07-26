require 'rails_helper'
require 'support/worker_authentication'

describe 'Signing out' do
  it 'removes the worker id from the session' do
    worker = FactoryGirl.create(:worker)

    worker_sign_in(worker)

    click_link 'Sign Out'

    expect(current_path).to eq(root_path)

    expect(page).to have_text('signed out')
    expect(page).not_to have_link('Sign Out')
    expect(page).to have_link('Sign In')
  end
end
