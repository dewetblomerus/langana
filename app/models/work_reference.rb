class WorkReference < ActiveRecord::Base
  belongs_to :employer
  belongs_to :worker

  validates :work, presence: true
end
