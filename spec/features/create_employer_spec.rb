require 'rails_helper'

describe 'Creating a new user' do
  it "shows the employer signup page", :vcr do
    visit choose_role_path

    click_link 'I am wanting to hire'

    expect(current_path).to eq(new_employer_registration_path)
  end
end
