abort('No file input found.') if ARGV[0].nil?

def stream_start(datastream, bit_length)
  datastream.chars.each_cons(bit_length).with_index do |bit, i|
    return i + bit_length if bit.uniq.length == bit_length
  end
end

stream = File.open(ARGV[0]).readlines(chomp: true)
puts 'Data stream starts'
stream.each { |input| p stream_start(input, 4) }

puts 'Message stream starts'
stream.each { |input| p stream_start(input, 14) }
