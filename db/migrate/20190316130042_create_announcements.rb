class CreateAnnouncements < ActiveRecord::Migration[5.2]
  def change
    create_table :announcements do |t|
      t.text :description
      t.string :status
      t.integer :user_id, index: true

      t.timestamps
    end
  end
end
