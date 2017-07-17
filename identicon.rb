require 'digest'
require 'chunky_png'

height = ARGV[0].to_i
username = ARGV[1]
circles = ARGV[2] || false

png_size = 800

if username.nil? or height.nil? or height > 15 or height % 2 == 0
  abort("Your command line arguments are incorrect.")
end

width = height / 2 + 1

digest = Digest::SHA512.new

digest.update username
hash = digest.hexdigest[0..width * height].scan(Regexp.new(".{1,#{width}}"))
color = hash.pop

display = []

hash.each do |v|
  a = v.split("").map { |e| e.to_i(16) % 2 }
  display << a.concat(a[0..width-2].reverse)
end

cells = png_size - png_size % height
divisor = cells / height
png = ChunkyPNG::Image.new(cells, cells, ChunkyPNG::Color::TRANSPARENT)

hue = color.to_i(16) * 360 / 15 

cells.times do |i|
  cells.times do |j|
    x = ( i % divisor - divisor / 2.0)
    y = ( j % divisor - divisor / 2.0)
    len = Math.sqrt(x**2 + y**2) 
    if !circles || (len < divisor / 2 && len > divisor / 3) 
      png[j,i] = display[i/divisor][j/divisor] == 1 ? ChunkyPNG::Color.from_hsl(hue,1,0.65) : ChunkyPNG::Color.from_hsl(0,1,1,0)
    end
  end
end

png.save("images/identicon#{height}.png", :interlace => true)
