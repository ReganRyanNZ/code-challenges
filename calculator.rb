# This code is officially the worst code I've ever written!
# I thought it might be worth keeping.
#
# The basic idea is that you can calculate any basic math problem
# e.g. > calc("4 + (-5 * (9 / 2)) - 5")
#
# The mixture of recursion and heavy regex use makes this code very difficult to maintain.


def calc expression
  # recursively solve brackets first
  bracket = 0
  expression.chars.each_with_index do |ch, i|
    if ch == '('
      index = i
      bracket = 1
      while(bracket != 0) do
        index += 1
        bracket += 1 if expression[index] == '('
        bracket -= 1 if expression[index] == ')'
      end
      return calc(expression[0...i] + calc(expression[i+1...index]).to_s + expression[index+1..-1])
    end
  end

  # do * and / in order
  expression.gsub!(/\s+/, "")
  muti_div_chars = expression.gsub(/[^\/\*]/, '').chars
  muti_div_chars.each do |ch|
    if ch == '*'
      expression.sub!(/(\-?[0-9]+(?:\.[0-9]+)?)\*([\-\+]?[0-9]+(?:\.[0-9]+)?)/) {'+'+($1.to_f * $2.to_f).to_s}
    elsif ch == '/'
      expression.sub!(/(\-?[0-9]+(?:\.[0-9]+)?)\/([\-\+]?[0-9]+(?:\.[0-9]+)?)/) {'+'+($1.to_f / $2.to_f).to_s}
    end
  end

  # get rid of double -- and ++ and then do + and - recursively
  case expression
  when /\-\-/
    return calc(expression.sub(/\-\-/, '+'))

  when /(\+\-)|(\-\+)/
    return calc(expression.sub(/(\+\-)|(\-\+)/, '-'))

  when /\+\+/
    return calc(expression.sub(/\+\+/, '+'))

  when /((?:\A\-)?[0-9]+(?:\.[0-9]+)?)\+([0-9]+(?:\.[0-9]+)?)/
    return calc(expression.sub(/((?:\A\-)?[0-9]+(?:\.[0-9]+)?)\+([0-9]+(?:\.[0-9]+)?)/) {($1.to_f + $2.to_f).to_s})

  when /((?:\A\-)?[0-9]+(?:\.[0-9]+)?)\-([0-9]+(?:\.[0-9]+)?)/
    return calc(expression.sub(/((?:\A\-)?[0-9]+(?:\.[0-9]+)?)\-([0-9]+(?:\.[0-9]+)?)/) {($1.to_f - $2.to_f).to_s})
  end

  expression.to_f
end