class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.text :text
      t.string :stats
      t.integer :manager_id
      t.integer :ticket_id

      t.timestamps
    end
  end
end
