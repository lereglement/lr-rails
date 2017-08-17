class AddErrorField < ActiveRecord::Migration[5.1]
  def change
    add_column :tracks, :error_logs, :string
  end
end
