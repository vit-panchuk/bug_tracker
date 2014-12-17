class Ticket < ActiveRecord::Base
  attr_accessible :email, :issue, :manager_id, :name, :stats, :subject, :key, :id
  validates :email, :issue, :name, :subject, presence: true
  belongs_to :manager
  has_many :replies, dependent: :destroy
  after_create :generate_key

  STATS = {
  	unconfirmed: 'Unconfirmed',
  	waiting_for_staff_response: 'Waiting for Staff Response',
  	waiting_for_customer: 'Waiting for Customer',
  	on_hold: 'On Hold',
  	cancelled: 'Cancelled',
  	completed: 'Completed'
  }
  STAFF_STATS = {
    new_unassigned_tickets: 'New Unassigned Tickets',
    open_tickets: 'Open Tickets',
    on_hold_tickets: 'On Hold Tickets',
    closed_tickets: 'Closed Tickets'
  }


private
	LETTERS = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J']

  def generate_key
    str = id.to_s.reverse
    str << '0'*(9-str.length)
    k, i = '', 0
    str.each_char do |chr|
    	if i < 3
    		k << LETTERS[chr.to_i]
    		k << '-' if 2 == i
    	else
    		k << chr
    	end
    	i += 1
    end
    self.key = k
    save
  end
end
