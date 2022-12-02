inventory = File.open("#{__dir__}/day1_input.txt") { |file| file.readlines(chomp: true) }

elves = inventory.slice_when do |i, _|
  i.length.zero?
end

# Part 1
ans1 = elves.reduce(0) do |memo, elf|
  total = elf.reduce(0) { |sum, item| sum + item.to_i }
  memo = total > memo ? total : memo
  memo
end

# Part 2
ans2 = elves.map do |elf|
  total = elf.reduce(0) { |sum, item| sum + item.to_i }
  total
end

puts "Single elf high: #{ans1}"
puts "Top three elves: #{ans2.sort.last(3).sum}"
