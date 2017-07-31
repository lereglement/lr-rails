class DefaultState < ActiveRecord::Migration[5.1]
  def change
    change_column_default :tracks, :state, :pending
  end
end
