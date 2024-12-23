input = File.read('input.txt')
lines = input.split(/(do\(\))|(don't\(\))/)

valid_lines = []
deleting = false
lines.each do |line|
    deleting = line.match(/^don't\(\)$/) or (deleting and !line.match(/^do\(\)$/))
    valid_lines << line unless deleting
end

matches = valid_lines.join.scan(/mul\((\d{1,3}),(\d{1,3})\)/)
puts matches.sum { |first, second| first.to_i * second.to_i }