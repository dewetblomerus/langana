class AddVerificationCodesSentToWorkers < ActiveRecord::Migration
  def change
    add_column :workers, :verification_codes_sent, :integer, default: 0
  end
end
