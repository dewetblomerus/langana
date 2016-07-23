require 'rails_helper'

describe 'Editing a worker' do
  it "updates a worker and shows the worker's updated details" do
    worker = FactoryGirl.create(:worker,
                                home_language: 'English'
                               )
    worker_sign_in(worker)
    visit worker_url(worker)
    click_link 'Edit Account'
    expect(current_path).to eq(edit_worker_path(worker))
    expect(find_field('worker_home_language').value).to eq(worker.home_language)
    fill_in 'Home language', with: 'Updated worker Home Language'
    click_button 'Update Account'
    expect(current_path).to eq(worker_path(worker))
    expect(page).to have_text('Updated worker Home Language')
    expect(page).to have_text('Account successfully updated!')
  end

  it "does not update the worker if it's invalid" do
    worker = FactoryGirl.create(:worker)
    worker_sign_in(worker)
    visit edit_worker_url(worker)
    fill_in 'worker_first_name', with: ' '
    click_button 'Update Account'
    expect(page).to have_text('error')
  end
end
