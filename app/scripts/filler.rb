# encoding: UTF-8
def parse_for_images(dir)
  image_formats = ['.jpg', '.jpeg', '.png']

  Dir.chdir(dir)
  Dir.glob('*').select do |file|

    if image_formats.include? File.extname(file).downcase

      label = File.basename(file, '.*')
      full_path = "#{@path}/#{dir}/#{file}"
      puts "Preparing: #{label}"
      puts "File: #{full_path}"

      binary_file = File.open(file, 'rb')

      params = {
        state: :published,
        user_id: @user[:id],
        item: binary_file,
        type_of: label == "_portrait_" ? :portrait : :picture,
        label: label != "_portrait_" && label[0,4] != "null" ? label : nil
      }
      Medium.create(params)

    end
  end

end

# Clean cache
FileUtils.rm_rf("#{Rails.application.secrets.path_static}/cache")

@path = "#{Rails.root}/bucket/filler"
Dir.chdir(@path)
dirs = Dir.glob('*').sort.select {|f| File.directory? f}

dirs.each do |dir|
  puts dir.upcase
  _, name, age, gender, latitude, longitude = dir.split("§")
  gender = gender == "1" ? :male : :female
  gender_target = gender == :male ? :female : :male

  Dir.chdir(@path)
  description = File.open(dir + '/description.txt', 'rb').read

  puts "USER: #{name}, #{age} ans, #{gender}"
  puts description
  puts "================================================"

  user_params = {
    first_name: name,
    age: age,
    gender: gender,
    gender_target: gender_target,
    description: description,
    latitude: latitude,
    longitude: longitude,
    state: :active,
    is_onboarded: true,
  }
  @user = User.create(user_params)

  parse_for_images(dir)

end
