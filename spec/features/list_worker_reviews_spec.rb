require 'rails_helper'

describe 'Given worker with a reference from an employer' do
  before do
    @employer = FactoryGirl.create(:employer, first_name: 'Empla', mobile_number: '0792951234')
    @worker = FactoryGirl.create(:worker, first_name: 'Workie', mobile_number: '0729251234')
    @review = WorkReference.create(
      work: 'IT',
      comment: 'The best IT work ever!!!',
      worker: @worker,
      employer: @employer
    )
  end

  describe 'when users gives reviews, it lists the reviews on profile page' do
    it 'lists reviews' do
      sign_in(@employer)

      visit worker_url(@worker)

      expect(page).to have_text(@review.work)
      expect(page).to have_text(@review.comment)
    end
  end
end
