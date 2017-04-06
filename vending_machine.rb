# for given money and price of item, give the correct change in the least amount of coins
def getChange(m, price)

  cents = (m*100 - price*100).to_i
  denominations = [100, 50, 25, 10, 5, 1]

  denominations.map do |v|
    result = cents / v
    cents %= v
    result
  end.reverse
end