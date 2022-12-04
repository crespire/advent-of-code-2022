# input file
# split the pairs, then split each assignment by '-' to get the ends, convert them to numbers
# make range arrays from the pairs.
# intersect arrays, does intersect equal shorter array?

assignments = File.open(ARGV[0]).readlines(chomp: true)
                  .map do |pair|
                    pair.split(',').map { |range| range.split('-').map(&:to_i) }
                        .map! { |numbers| (numbers.first..numbers.last).to_a }
                  end

full_overlap = assignments.select do |pair|
  intersect = pair[0] & pair[1]
  next unless intersect.length.positive?

  shorter = pair[0].length > pair[1].length ? pair[1] : pair[0]
  intersect == shorter
end
puts "Full overlaps: #{full_overlap.length}"


# looser matching, is there any intersect at all?
partial_overlap = assignments.select do |pair|
  intersect = pair[0] & pair[1]
  intersect.length.positive?
end

puts "Partial overlaps: #{partial_overlap.length}"
