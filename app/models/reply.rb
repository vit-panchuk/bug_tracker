class Reply < ActiveRecord::Base
  attr_accessible :manager_id, :stats, :text, :ticket_id
  validates :manager_id, :stats, :text, :ticket_id, presence: true
  belongs_to :ticket
  belongs_to :manager
end
