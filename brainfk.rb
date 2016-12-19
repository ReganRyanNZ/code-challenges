def brain_luck(code, input)
  output = ''
  cp = 0 # code pointer
  dp = 0 # data pointer
  ip = 0 # input pointer
  data = Array.new(10, 0)
  while cp < code.length
    case code[cp]
    when '>'
      dp += 1
      if dp == data.length
        data.push(0)
      end
    when '<'
      dp -= 1
      if dp == -1
        dp = 0
        data.unshift(0)
      end
    when '+'
      data[dp] = (data[dp].ord+1)%256
    when '-'
      data[dp] = (data[dp].ord-1)%256
    when '.'
      output += data[dp].chr
    when ','
      data[dp] = input[ip].ord
      ip += 1
    when '['
      if data[dp] == 0
        nest_count = 1
        while nest_count > 0
          case code[cp += 1]
          when '[' then nest_count += 1
          when ']' then nest_count -= 1
          end
        end
      end
    when ']'
      if data[dp] != 0
        nest_count = 1
        while nest_count > 0
          case code[cp -= 1]
          when ']' then nest_count += 1
          when '[' then nest_count -= 1
          end
        end
      end
    end
    cp += 1
  end
  output
end