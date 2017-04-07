POINTS = [1,3,3,2,1,4,2,4,1,8,10,1,2,1,1,3,8,1,1,1,1,4,10,10,10,10]

def get_best_word(points, array)
  alphabet = ("A".."Z").to_a
  list = array.map {|word| word.split("").map {|letter| POINTS[alphabet.index(letter)]}}
  size_score = list.map {|score| [score.size, score.reduce(:+)]}
  max_score = list.map {|score| score.reduce(:+)}.max
  top_words = size_score.select {|x| x[1] == max_score}
  final = top_words.select{|x| x[0] == top_words.map {|x| x[0]}.min}
  size_score.index(final[0])
end
