class MathLib

  def self.bytes_to_megabytes(bytes)
    (bytes / (1024.0 * 1024.0)).round(1)
  end

  def self.format_size(bytes)
    mb = (bytes / (1024.0 * 1024.0)).round(1)
    if mb < 1
      "#{(bytes / 1204.0).to_i} Kb"
    else
      "#{mb} Mb"
    end
  end


end
