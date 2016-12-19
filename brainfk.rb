# The following is from the original challenge:

# https://www.codewars.com/kata/my-smallest-code-interpreter-aka-brainf-star-star-k/ruby

# Inspired from real-world Brainf**k, we want to create an interpreter of that language which will support the following instructions (the machine memory or 'data' should behave like a potentially infinite array of bytes, initialized to 0):

# `>` increment the data pointer (to point to the next cell to the right).
# `<` decrement the data pointer (to point to the next cell to the left).
# `+` increment (increase by one, truncate overflow: 255 + 1 = 0) the byte at the data pointer.
# `-` decrement (decrease by one, treat as unsigned byte: 0 - 1 = 255 ) the byte at the data pointer.
# `.` output the byte at the data pointer.
# `,` accept one byte of input, storing its value in the byte at the data pointer.
# `[` if the byte at the data pointer is zero, then instead of moving the instruction pointer forward to the next command, jump it forward to the command after the matching ] command.
# `]` if the byte at the data pointer is nonzero, then instead of moving the instruction pointer forward to the next command, jump it back to the command after the matching [ command.
# The function will take in input...

# the program code, a string with the sequence of machine instructions,
# the program input, a string, eventually empty, that will be interpreted as an array of bytes using each character's ASCII code and will be consumed by the `,` instruction
# ... and will return ...

# the output of the interpreted code (always as a string), produced by the `.` instruction.


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