abort('No input file...') if ARGV[0].nil?
input = File.open(ARGV[0]).readlines(chomp: true).map(&:chars).map { |line| line.map(&:to_i) }

def tree_vis(map)
  visible = []
  transposed = map.transpose
  map.each_with_index do |line, i|
    line.each_with_index do |tree, j|
      if (i - 1).negative? || (i + 1 > map.length - 1)
        visible << tree
        next
      end
  
      if (j - 1).negative? || (j + 1 > line.length - 1)
        visible << tree
        next
      end

      slice_left = line[0..j - 1]
      slice_right = line[j + 1..]
      slice_up = transposed[j][0..i - 1]
      slice_down = transposed[j][i + 1..]

      if slice_left.all? { |other| tree > other } || slice_right.all? { |other| tree > other }
        visible << tree
        next
      end

      if slice_up.all? { |other| tree > other } || slice_down.all? { |other| tree > other }
        visible << tree
        next
      end
    end
  end
  visible
end

def tree_score(map)
  scores = []
  transposed = map.transpose
  map.each_with_index do |line, i|
    line.each_with_index do |tree, j|
      slice_left = (j - 1).negative? ? [] : line[0..j - 1].reverse
      slice_right = (j + 1) > line.length ? [] : line[j + 1..]
      slice_up = (i - 1).negative? ? [] : transposed[j][0..i - 1].reverse
      slice_down = (i + 1) > line.length ? [] : transposed[j][i + 1..]

      keep_up = []
      slice_up.each do |other|
        keep_up << other
        break if tree <= other
      end
      next if keep_up.length.zero?

      keep_left = []
      slice_left.each do |other|
        keep_left << other
        break if tree <= other
      end
      next if keep_left.length.zero?

      keep_right = []
      slice_right.each do |other|
        keep_right << other
        break if tree <= other
      end
      next if keep_right.length.zero?

      keep_down = []
      slice_down.each do |other|
        keep_down << other
        break if tree <= other
      end
      next if keep_down.length.zero?

      scores << keep_up.length * keep_left.length * keep_right.length * keep_down.length
    end
  end
  scores
end

visible = tree_vis(input)
p visible.length

scores = tree_score(input)
p scores.max
