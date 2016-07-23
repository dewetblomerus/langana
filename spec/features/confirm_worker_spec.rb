require 'rails_helper'

describe 'Confirming a mobile number' do
  it 'confirms with the correct mobile confirmation code' do
    worker = FactoryGirl.create(:worker, mobile_confirmation_code: 'abcde', confirmed_at: nil)
    expect(worker.confirmed_at).to be_nil
    worker_sign_in(worker)
    visit confirm_worker_path(worker)
    fill_in 'Mobile confirmation code', with: 'abcde'
    click_button 'Confirm Mobile Number'
    expect(page).to have_text('Thanks for confirming your mobile number!')
    worker.reload
    expect(worker.confirmed_at).not_to be_nil
  end

  it 'does not confirm with the incorrect mobile confirmation code' do
    worker = FactoryGirl.create(:worker, mobile_confirmation_code: 'abcde', confirmed_at: nil)
    expect(worker.confirmed_at).to be_nil
    worker_sign_in(worker)
    visit confirm_worker_path(worker)
    fill_in 'Mobile confirmation code', with: ''
    click_button 'Confirm Mobile Number'
    expect(page).to have_text('Incorrect confirmation code')
    expect(worker.confirmed_at).to be_nil
  end

  it 'resends verification code when the worker requests it', :vcr do
    worker = FactoryGirl.create(:worker, mobile_confirmation_code: 'abcde', confirmed_at: nil)
    expect(worker.confirmed_at).to be_nil
    worker_sign_in(worker)
    visit confirm_worker_path(worker)
    click_link 'Resend verification'
    expect(page).to have_text('We sent it again')
  end

  it 'show a button to confrim in the header if worker is not confirmed' do
    worker = FactoryGirl.create(:worker, mobile_confirmation_code: 'abcde', confirmed_at: nil)
    worker_sign_in(worker)
    expect(page).to have_text('Confirm phone number')
  end
end
