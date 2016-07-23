require 'rails_helper'

describe 'Viewing an individual worker' do
  let (:worker) { FactoryGirl.create(:worker) }
  let (:employer) { FactoryGirl.create(:employer) }

  it 'goes to workers show page from root page' do
    worker = FactoryGirl.create(:worker)
    visit '/'

    worker_sign_in(worker)
    click_link(worker.first_name)
    expect(page).to have_text(worker.first_name)
    expect(page).to have_text(worker.last_name)
    expect(page).to have_text(worker.home_language)
    expect(page).to have_text(worker.mobile_number)
  end

  it "shows a worker's details to confirmed potential employers", :skip do
    sign_in(employer)
    visit worker_url(worker)
    expect(page).to have_text(worker.first_name)
    expect(page).to have_text(worker.email)
  end

  it 'redirect unconfirmed employers to their sign in page', :skip do
    employer = FactoryGirl.create(:employer)
    sign_in(employer)
    visit worker_url(worker)
    expect(current_path).to eq(new_employer_session_path)
  end
end
