require 'digest'
require 'chunky_png'

username = "joshddunn"

digest = Digest::MD5.new
digest.update username
hash = digest.hexdigest[0..15].scan(/.{1,3}/)
color = hash.pop
display = []

hash.each do |v|
  a = v.split("").map { |e| e.to_i(16) % 2 }
  display << a.concat(a[0..1].reverse)
end

cells = 200
divisor = cells / 5
png = ChunkyPNG::Image.new(cells, cells, ChunkyPNG::Color::TRANSPARENT)

hue = color.to_i(16) * 24

cells.times do |i|
  cells.times do |j|
    png[j,i] = display[i/divisor][j/divisor] == 1 ? ChunkyPNG::Color.from_hsl(hue,1,0.65) : ChunkyPNG::Color.from_hsl(0,1,1)
  end
end

png.save('identicon.png', :interlace => true)
