require 'rails_helper'
require 'support/worker_authentication'

describe 'Creating a new work reference', :skip do
  it "saves work reference and shows reference on the user's detail page" do
    employer = FactoryGirl.create(:employer)
    worker = FactoryGirl.create(:worker,
                                first_name: 'Jeremy',
                                last_name: 'Ramos',
                                mobile_number: '0723423458',
                                password: 'secret',
                                password_confirmation: 'secret'
                               )

    sign_in(employer)

    visit worker_path(worker)

    click_link 'Give Reference'

    expect(current_path).to eq(new_worker_work_reference_path(worker))

    fill_in "What work did #{worker.first_name} do for you?", with: "#{worker.first_name} fixed my computer"

    fill_in 'Comment', with: 'They installed more ram. I could not be happier'

    click_button 'Save Reference'

    expect(current_path).to eq(worker_path(worker))

    expect(page).to have_text('Thanks for giving a reference!')
    expect(page).to have_text('They installed more ram')
  end

  it "does not save the review if it's invalid" do
    employer = FactoryGirl.create(:employer)
    worker = FactoryGirl.create(:worker,
                                first_name: 'Other',
                                last_name: 'Person',
                                mobile_number: '0723423459',
                                password: 'secret',
                                password_confirmation: 'secret'
                               )

    sign_in(employer)

    visit worker_path(worker)

    click_link 'Give Reference'

    expect do
      click_button 'Save Reference'
    end.not_to change(WorkReference, :count)

    expect(page).to have_text('error')
  end
end
