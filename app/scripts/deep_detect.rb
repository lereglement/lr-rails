# c = Curl::Easy.new
# url = "http://91.224.148.180:18083/predict"
# puts DeepDetectLib.faces("http://i.imgur.com/QiksDIs.jpg")
# file = Base64.strict_encode64(File.open("/app/static/cache/000/000/070/70.jpeg", "rb").read)
file = Base64.encode64(File.open("/app/public/admin/logo.png", "rb").read)

# puts file

# File.open('decode.jpeg', 'wb') do|f|
#   f.write(Base64.decode64(file))
# end

# puts file
hash = DeepDetectLib.faces(file)

puts hash["status"]["code"]



# puts DeepDetectLib.faces("http://media.cntraveler.com/photos/58acc05a29676a553e60ced1/master/w_775,c_limit/dreamland-bali-GettyImages-544489350.jpg")
