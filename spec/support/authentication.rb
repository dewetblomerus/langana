def worker_sign_in(worker)
  visit new_session_url
  fill_in 'Mobile number', with: worker.mobile_number
  fill_in 'Password', with: worker.password
  click_button 'Sign In'
end
