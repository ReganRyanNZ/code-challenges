# Genetic Algorithm
#
# This is an answer to code challenge https://www.codewars.com/kata/binary-genetic-algorithms/train/ruby
#
# I received the fitness measuring method as input. Other than that, I made a fully functioning GA.
#
# This uses integers as arrays of bits (strings were inefficient).
# This started off as a genetic algorithm learning exercise, and quickly evolved into a bitwise operations learning exercise.
# In this challenge I learned a great deal about getting and setting bits, bit masking, and running benchmark tests.

class GeneticAlgorithm

  def generate length
    rand(1<<length)
  end

  def select population, fitnesses, total_weight
    # weights are in floats, so bump up and down for precision
    target = rand((total_weight*64))/64.0
    fitnesses.each_with_index do |f, i|
      target -= f
      return population[i] if target < 0
    end
  end

  def mutate chromosome, p, length
    length.times do |i|
      if rand < p
        chromosome = chromosome ^ 1 << i
      end
    end
    chromosome
  end

  def crossover chromosome1, chromosome2, length
    i = rand(length+1)
    mask1 = (1<<i) - 1
    mask2 = (1<<(length-i)) - 1 << i

    [
      (chromosome1 & mask1) + (chromosome2 & mask2),
      (chromosome1 & mask2) + (chromosome2 & mask1)
    ]
  end

  def run fitness, length, p_c, p_m, iterations=100
    generation = 100.times.map { generate length }
    iterations.times do
      fitnesses_weight = 0.0
      fitnesses = generation.map { |chr|
        f = fitness.call(chr)
        fitnesses_weight += f
        f
      }

      new_gen = []
      (generation.size/2).times do
        chr1 = select(generation, fitnesses, fitnesses_weight)
        chr2 = select(generation, fitnesses, fitnesses_weight)
        chr1, chr2 = crossover(chr1, chr2, length) if rand < p_c
        chr1 = mutate(chr1, p_m, length)
        chr2 = mutate(chr2, p_m, length)
        new_gen << chr1
        new_gen << chr2
      end
      generation = new_gen
    end
    fitnesses = generation.map { |chr| fitness.call(chr) }
    strongest = fitnesses.each_with_index.max[1]
    generation[strongest]
  end
end