inventory = File.open("#{__dir__}/day1_input.txt").read.split("\n\n").map { |elf| elf.split.map(&:to_i).sum }

puts "Max single: #{inventory.max}"
puts "Top three totalL: #{inventory.max(3).sum}"
