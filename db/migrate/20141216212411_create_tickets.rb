class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :name
      t.string :email
      t.string :subject
      t.text :issue
      t.string :stats
      t.integer :manager_id

      t.timestamps
    end
  end
end
