class AddKeyToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :key, :string
  end
end
