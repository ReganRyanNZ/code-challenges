# for given money and price of item, give the correct change in the least amount of coins
def getChange(m, price)

  cents = (m*100 - price*100).to_i
  denominations = [200, 100, 50, 20, 10]

  denominations.map do |v|
    result = cents / v
    cents %= v
    result.to_s + "x" + v.to_s
  end
end