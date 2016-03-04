class CreateHipchatConfigs < ActiveRecord::Migration
  def change
    create_table :hipchat_configs do |t|
      t.string :room_id, null: false, unique: true
      t.string :token
      t.string :oauth_id
      t.string :oauth_secret

      t.timestamps null: false
    end
    add_index :hipchat_configs, :room_id
  end
end
