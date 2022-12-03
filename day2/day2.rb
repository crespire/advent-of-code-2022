points_map = {
  'X' => 1,
  'Y' => 2,
  'Z' => 3,
  'A' => 1,
  'B' => 2,
  'C' => 3
}

player_map = {
  'X' => 'A',
  'Y' => 'B',
  'Z' => 'C'
}

lose_map = {
  'A' => 'Z',
  'B' => 'X',
  'C' => 'Y'
}

win_map = {
  'A' => 'Y',
  'B' => 'Z',
  'C' => 'X'
}

rounds_strategy = File.open(ARGV[0])
                    .readlines(chomp: true)
                    .map do |round|
                      score = 0
                      moves = round.split
                      next_char = 65 + (((moves[0].ord - 65) + 1) % 3)
                      score += 6 if next_char.chr == player_map[moves[1]]
                      score += 3 if moves[0] == player_map[moves[1]]
                      score += points_map[moves[1]]
                      score
                    end

p rounds_strategy.sum


rounds_strategy2 = File.open(ARGV[0])
                    .readlines(chomp: true)
                    .map do |round|
                      score = 0
                      moves = round.split
                      score = points_map[moves[0]] + 3 if moves[1] == 'Y'

                      unless moves[1] == 'Y'
                        player_move = moves[1] == 'X' ? lose_map[moves[0]] : win_map[moves[0]]
                        round_score = moves[1] == 'X' ? 0 : 6
                        score += round_score + points_map[player_move]
                      end
                      score
                    end

p rounds_strategy2.sum
