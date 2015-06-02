require 'rails_helper'

describe "Signing in" do

  it "prompts for a mobile number and password" do
    visit root_url

    click_link 'Sign In'

    expect(current_path).to eq(signin_path)

    expect(page).to have_field("Mobile number")
    expect(page).to have_field("Password")
  end

  it "signs in the user if the mobile number/password combination is valid" do
    user = User.create!(user_attributes)

    visit root_url

    click_link 'Sign In'

    fill_in "Mobile number", with: user.mobile_number
    fill_in "Password", with: user.password

    click_button 'Sign In'

    expect(current_path).to eq(user_path(user))

    expect(page).to have_text("Welcome back, #{user.name}!")

    expect(page).to have_link(user.name)
    expect(page).not_to have_link('Sign In')
    expect(page).not_to have_link('Sign Up')
    expect(page).to have_link('Account Settings')
    expect(page).to have_link('Sign Out')
  end

  it "does not sign in the user if the mobile number/password combination is not valid" do
    user = User.create!(user_attributes)

    visit root_url

    click_link 'Sign In'

    fill_in "Mobile number", with: user.mobile_number
    fill_in "Password", with: "no match"

    click_button 'Sign In'

    expect(page).to have_text('Invalid')
    expect(page).not_to have_link(user.name)
    expect(page).to have_link('Sign In')
    expect(page).to have_link('Sign Up')
    expect(page).not_to have_link('Sign Out')
  end

  it "redirects to the intended page" do
    user1 = User.create!(user_attributes)
    user2 = User.create!({
                        first_name: "Other",
                        mobile_number: "0761231234",
                        password: "secret",
                        password_confirmation: "secret"
                      })

    visit user_path(user2)

    expect(current_path).to eq(new_session_path)

    sign_in(user1)

    expect(current_path).to eq(user_path(user2))
  end

end
