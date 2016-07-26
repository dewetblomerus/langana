require 'rails_helper'

describe "Resetting a worker's password" do
  it 'has a link to it' do
    visit signin_path
    click_link('Forgot your password?')
    expect(current_path).to eq(forgot_password_path)
    expect(page).to have_text("Don't worry")
  end

  it "takes a mobile number & sends a reset code if it's found in the databse", :vcr do
    allow(ConfirmationCode).to receive(:random_code).and_return('abcde')
    worker = FactoryGirl.create(:worker, mobile_number: '+27795555555', mobile_confirmation_code: 'abcde')
    visit forgot_password_path
    fill_in 'Mobile number', with: worker.mobile_number
    click_button 'Reset password'
    expect(current_path).to eq(new_password_worker_path(worker))
    fill_in 'Mobile confirmation code', with: 'abcde'
    fill_in 'worker_password', with: 'sdfsdf'
    fill_in 'worker_password_confirmation', with: 'sdfsdf'
    click_button 'Change Password'
    expect(current_path).to eq(worker_path(worker))
    expect(page).to have_text('Password reset successful')
  end

  it "takes a mobile number & notifies the worker if it's not found in the databse" do
    visit forgot_password_path
    fill_in 'Mobile number', with: '0797777777'
    click_button 'Reset password'
    expect(current_path).to eq(forgot_password_path)
    expect(page).to have_text('No account with that phone number')
  end

  it 'only accepts the reset code one time', :vcr do
    worker = FactoryGirl.create(:worker, mobile_number: '+27795555555', mobile_confirmation_code: 'abcde')
    visit forgot_password_path
    fill_in 'Mobile number', with: worker.mobile_number
    click_button 'Reset password'
    expect(current_path).to eq(new_password_worker_path(worker))
    fill_in 'Mobile confirmation code', with: 'abcde'
    fill_in 'worker_password', with: 'sdfsdf'
    fill_in 'worker_password_confirmation', with: 'sdfsdf'
    click_button 'Change Password'
    visit new_password_worker_path(worker)
    fill_in 'Mobile confirmation code', with: 'abcde'
    fill_in 'worker_password', with: 'sdfsdf'
    fill_in 'worker_password_confirmation', with: 'sdfsdf'
    click_button 'Change Password'
    expect(page).to have_text('Incorrect confirmation code')
    # This spec passed before the feature was implemented, I need help
  end
end
