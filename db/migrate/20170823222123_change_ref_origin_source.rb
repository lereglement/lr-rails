class ChangeRefOriginSource < ActiveRecord::Migration[5.1]
  def change
    change_column :tracks, :ref_external_source, :string, limit: 180

  end
end
