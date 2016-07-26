require 'rails_helper'
require 'support/worker_authentication'

describe 'Deleting a worker' do
  xit 'destroys the worker and redirects to the home page' do
    worker = FactoryGirl.create(:worker)

    worker_sign_in(worker)

    visit worker_path(worker)

    click_button 'Delete Account'

    expect(current_path).to eq(root_path)
    expect(page).to have_text('Account successfully deleted!')

    visit workers_path

    expect(page).not_to have_text(worker.name)
  end

  it 'automatically signs out that worker' do
    worker = FactoryGirl.create(:worker)

    worker_sign_in(worker)

    visit worker_path(worker)
    click_link 'Delete Account'

    expect(page).to have_link('Sign In')
    expect(page).not_to have_link('Sign Out')
  end
end
