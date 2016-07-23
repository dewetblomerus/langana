require 'rails_helper'

describe 'given a worker review from an employer to a worker' do
  before do
    @employer = FactoryGirl.create(:employer)
    @worker = FactoryGirl.create(:worker,
                                first_name: 'Jeremy',
                                last_name: 'Ramos',
                                mobile_number: '0723423458',
                                password: 'secret',
                                password_confirmation: 'secret'
                               )
    @work_reference = FactoryGirl.create(:work_reference,
                                        worker: @worker,
                                        employer: @employer
                                        )
  end

  describe 'when i delete the worker' do
    it 'then the review should no longer exist' do
      work_references_count = WorkReference.all.count
      @worker.destroy
      expect work_references_count != WorkReference.all.count
      error = "Couldn't find WorkReference with 'id'=#{@work_reference.id}"
      expect { WorkReference.find(@work_reference.id) }.to raise_error error
    end
  end
end
