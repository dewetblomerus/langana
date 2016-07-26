require 'rails_helper'

describe 'Signing in' do
  it 'prompts for a mobile number and password' do
    visit root_url
    click_link 'Sign In'
    expect(current_path).to eq(signin_path)
    expect(page).to have_field('Mobile number')
    expect(page).to have_field('Password')
  end

  it 'signs in the worker if the mobile number/password combination is valid' do
    worker = FactoryGirl.create(:worker)
    visit root_url
    click_link 'Sign In'
    fill_in 'Mobile number', with: worker.mobile_number
    fill_in 'Password', with: worker.password
    click_button 'Sign In'
    expect(current_path).to eq(worker_path(worker))
    expect(page).to have_text("Welcome back, #{worker.first_name}!")
    expect(page).to have_link(worker.first_name)
    expect(page).not_to have_link('Sign In')
    expect(page).not_to have_link('Sign Up')
    expect(page).to have_link('Account Settings')
    expect(page).to have_link('Sign Out')
  end

  it 'accepts the  mobile number formatted as local' do
    worker = FactoryGirl.create(:worker, mobile_number: '+27791231239')
    visit root_url
    click_link 'Sign In'
    fill_in 'Mobile number', with: '0791231239'
    fill_in 'Password', with: worker.password
    click_button 'Sign In'
    expect(current_path).to eq(worker_path(worker))
    expect(page).to have_text("Welcome back, #{worker.first_name}!")
  end

  it 'does not sign in the worker if the mobile number/password combination is not valid', :skip do
    worker = FactoryGirl.create(:worker)
    visit root_url
    click_link 'Sign In'
    fill_in 'Mobile number', with: worker.mobile_number
    fill_in 'Password', with: 'no match'
    click_button 'Sign In'
    expect(page).to have_text('Invalid')
    expect(page).not_to have_link(worker.first_name)
    expect(page).to have_link('Sign In')
    expect(page).to have_link('Sign Up')
    expect(page).not_to have_link('Sign Out')
  end

  it 'redirects to the intended page if confirmed', :skip do
    worker1 = FactoryGirl.create(:worker)
    worker2 = FactoryGirl.create(:worker,
                               first_name: 'Other',
                               last_name: 'Otherson',
                               mobile_number: '0761231234',
                               password: 'secret',
                               password_confirmation: 'secret'
                              )
    visit worker_path(worker2)
    expect(current_path).to eq(signin_path)
    worker_sign_in(worker1)
  end

  it 'redirects to the confirmation page if not confirmed' do
    worker = FactoryGirl.create(:worker, confirmed_at: nil)
    worker_sign_in(worker)
    expect(current_path).to eq(confirm_worker_path(worker))
  end
end
