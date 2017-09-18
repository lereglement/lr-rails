class Add < ActiveRecord::Migration[5.1]
  def change
    add_column :tracks, :external_published_at, :datetime

    # Track.where(origin_external_source: :youtube).each do |track|
    #   source_details = ExternalResourceLib.extract_from_url(track.external_source)
    #
    #   if source_details && source_details[:published_at] && !source_details[:published_at].blank?
    #     track.update_column(:external_published_at, source_details[:published_at])
    #   end
    # end
  end
end
