class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :consumers, :secret, :lti_secret
    rename_column :consumers, :key, :lti_key
  end
end
