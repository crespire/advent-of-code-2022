crates, instructions = File.open(ARGV[0]).read.split("\n\n")

def parse_crates(crates)
  lines = crates.split("\n").reverse.map { |line| line.scan(/(?:\s{3,4})|(?:\[\w\]\s?)|(?:\s+\d\s{0,2})/) }
  cols = lines.shift # Remove column count line
  stacks = Array.new(cols.length) { [] }
  lines.each do |items|
    items.each_with_index do |item, i|
      stacks[i].push(item)
    end
  end
  stacks.map { |col| col.filter { |item| item.start_with?('[') } }
end

def move_crates(crates, instructions, multi = false)
  steps = instructions.split("\n").map { |line| line.scan(/(?:\d+)/) }.map { |line| line.map(&:to_i) }
  steps.each do |step|
    to_move, from, to = *step
    to_move.times do
      crate = crates[from - 1].pop(multi ? to_move : 1)
      crates[to - 1].concat(crate)
      break if multi
    end
  end
  crates
end

def top_crates(crates)
  answer = []
  crates.each { |col| answer << col.dup.pop }
  answer
end

parsed = parse_crates(crates)

moved9000 = move_crates(Marshal.load(Marshal.dump(parsed)), instructions)
moved9001 = move_crates(Marshal.load(Marshal.dump(parsed)), instructions, 9001)

puts "With CrateMover 9000: #{top_crates(moved9000)}"
puts "With CrateMover 9001: #{top_crates(moved9001)}"
