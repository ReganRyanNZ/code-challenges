
def domino
  results = []
  File.open("input", "r") do |fh|
    while(line = fh.gets) != nil

      tiles = line.split(",").map { |t| t.split("-") }

      chain = 1
      chains = [1]

      tiles.each.with_index do |t, i|
        if i < (tiles.length-1)
          if t[1] == tiles[i+1][0]
            chain += 1
          else
            chains << chain
            chain = 1
          end
        else
          chains << chain
        end
      end
      results << chains.max
    end
  end
  p results
end

domino()
