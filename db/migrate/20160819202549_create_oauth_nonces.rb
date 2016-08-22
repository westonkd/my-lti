class CreateOauthNonces < ActiveRecord::Migration
  def change
    create_table :oauth_nonces do |t|
      t.string :value

      t.timestamps null: false
    end
  end
end
