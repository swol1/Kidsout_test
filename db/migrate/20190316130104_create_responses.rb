class CreateResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :responses do |t|
      t.integer :price
      t.string :status
      t.integer :user_id, index: true
      t.integer :announcement_id

      t.timestamps
    end
    add_index :responses, [:announcement_id, :user_id], where: "status != 'cancelled'", unique: true
  end
end
