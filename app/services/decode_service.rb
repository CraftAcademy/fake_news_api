module DecodeService
  def self.attach_image(file, target) 
    decoded_data = Base64.decode64(file[:data])
    io = StringIO.new
    io.puts(decoded_data)
    io.rewind
    target.image.attach(io: io, filename: "attachment.#{file[:extension]}")
  end
end
