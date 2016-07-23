require 'rails_helper'

describe 'Viewing the list of users' do
  it 'shows only the workers with confirmed mobile numbers' do
    legit_worker1 = FactoryGirl.create(:worker, first_name: 'LegitOne')
    legit_worker2 = FactoryGirl.create(:worker, first_name: 'LegitTwo')
    legit_worker3 = FactoryGirl.create(:worker, first_name: 'LegitThree')
    employer = FactoryGirl.create(:employer, first_name: 'Emplo')
    unconfirmed_worker = FactoryGirl.create(
      :worker,
      first_name: 'Unconfirmedworker',
      confirmed_at: nil
    )

    visit workers_url
    expect(page).to have_link(legit_worker1.first_name)
    expect(page).to have_text(legit_worker1.service)
    expect(page).to have_link(legit_worker2.first_name)
    expect(page).to have_link(legit_worker3.first_name)
    expect(page).not_to have_link(employer.first_name)
    expect(page).not_to have_link(unconfirmed_worker.first_name)
  end
end
