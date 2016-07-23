require 'rails_helper'

describe 'A worker' do
  it 'requires a first name' do
    worker = Worker.new(first_name: '')
    expect(worker.valid?).to eq(false)
    expect(worker.errors[:first_name].any?).to eq(true)
  end

  it 'requires a last name' do
    worker = Worker.new(last_name: '')
    expect(worker.valid?).to eq(false)
    expect(worker.errors[:last_name].any?).to eq(true)
  end

  it 'requires a mobile number' do
    worker = Worker.new(mobile_number: '')
    worker.valid? # populates errors
    expect(worker.errors[:mobile_number].any?).to eq(true)
  end

  it 'accepts properly formatted mobile numbers' do
    numbers = %w(+27791231231 0791231232)
    numbers.each do |number|
      worker = Worker.new(mobile_number: number)
      worker.valid?
      expect(worker.errors[:mobile_number].any?).to eq(false)
    end
  end

  xit 'accepts properly formatted but weirdly entered mobile numbers' do
    numbers = ['+27791231234', '0791231234', '079 123 1234', '0 7 9 1 2 3 1 2 3 4']
    numbers.each do |number|
      worker = Worker.new(number: number)
      worker.valid?
      expect(worker.errors[:number].any?).to eq(false)
    end
  end

  it 'rejects improperly formatted mobile number' do
    numbers = ['27791231234', '079 123 1234', '0 7 9 1 2 3 1 2 3 4']
    numbers.each do |number|
      worker = Worker.new(mobile_number: number)
      worker.valid?
      expect(worker.errors[:mobile_number].any?).to eq(true)
    end
  end

  it 'requires a unique mobile number' do
    worker1 = FactoryGirl.create(:worker)
    worker2 = Worker.new(mobile_number: worker1.mobile_number)
    worker2.valid?
    expect(worker2.errors[:mobile_number].first).to eq('has already been taken')
  end

  it 'is valid with example attributes' do
    worker = FactoryGirl.create(:worker)
    expect(worker.valid?).to eq(true)
  end

  it 'requires a password' do
    worker = Worker.new(password: '')
    worker.valid?
    expect(worker.errors[:password].any?).to eq(true)
  end

  it 'requires a password confirmation when a password is present' do
    worker = Worker.new(password: 'secret', password_confirmation: '')
    worker.valid?
    expect(worker.errors[:password_confirmation].any?).to eq(true)
  end

  it 'requires the password to match the password confirmation' do
    worker = Worker.new(password: 'secret', password_confirmation: 'nomatch')
    worker.valid?
    expect(worker.errors[:password_confirmation].first).to eq("doesn't match Password")
  end

  it 'requires a password and matching password confirmation when creating' do
    worker = FactoryGirl.create(:worker, password: 'secret', password_confirmation: 'secret')
    expect(worker.valid?).to eq(true)
  end

  it 'does not require a password when updating' do
    worker = FactoryGirl.create(:worker)
    worker.password = ''
    expect(worker.valid?).to eq(true)
  end

  it 'automatically encrypts the password into the password_digest attribute' do
    worker = Worker.new(password: 'secret')
    expect(worker.password_digest.present?).to eq(true)
  end
end

describe 'authenticate' do
  before do
    @worker = FactoryGirl.create(:worker)
  end

  it 'returns non-true value if the mobile number does not match' do
    expect(Worker.authenticate('666', @worker.password)).not_to eq(true)
  end

  it 'returns non-true value if the password does not match' do
    expect(Worker.authenticate(@worker.mobile_number, 'nomatch')).not_to eq(true)
  end

  it 'returns the worker if the email and password match' do
    expect(Worker.authenticate(@worker.mobile_number, @worker.password)).to eq(@worker)
  end
end
