sacks = File.open(ARGV[0]).readlines(chomp: true)

part1 = sacks.map do |sack|
                a, b = sack.chars.each_slice(sack.length / 2).to_a
                (a & b).pop
              end
              .map { |letter| letter.ord > 91 ? letter.ord - 96 : letter.ord - 38 }

p part1.sum

badges = []
part2 = sacks.each_slice(3) do |group|
                chars = group.map(&:chars)
                badge = chars[0] & chars[1] & chars[2]
                badges << badge.pop
              end
badges.map! { |letter| letter.ord > 91 ? letter.ord - 96 : letter.ord - 38 }
p badges.sum