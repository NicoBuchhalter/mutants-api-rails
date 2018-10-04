class Person < ApplicationRecord
  validates :dna, uniqueness: true
  validates :dna, presence: true

  validate :valid_dna

  scope :mutant, -> { where(mutant: true) }

  after_validation :detect_mutancy

  CONSECUTIVE_CHARACTERS_FOR_MUTANCY = 4

  def self.stats
    total = count
    mutant_count = mutant.count
    {
      count_mutant_dna: mutant_count,
      count_human_dna: total,
      ratio: (mutant_count.to_f / (total.zero? ? 1 : total)).round(2)
    }
  end

  private

  def valid_dna
    return if dna.blank?
    dna.each do |sequence|
      return errors.add(:dna, 'Must be NxN') if sequence.length != dna.size
    end
  end

  def detect_mutancy
    return if dna.blank?
    (0..dna.size).each do |i|
      (0..dna.size).each do |j|
        return self.mutant = true if check_all_directions(i, j)
      end
    end
  end

  def check_all_directions(i, j)
    directions = [[i, j + 1], [i + 1, j - 1], [i + 1, j], [i + 1, j + 1]]
    directions.each { |direction| return true if check_next(i, j, direction[0], direction[1], 0) }
    false
  end

  def check_next(current_i, current_j, next_i, next_j, count)
    return true if found_all_consecutive_characters?(count)
    return false if position_out_of_grid?(next_i, next_j)
    return false unless equal_characters_in_grid?(current_i, current_j, next_i, next_j)
    check_next(next_i, next_j, next_i + (next_i - current_i), next_j + (next_j - current_j), count + 1)
  end

  def position_out_of_grid?(i, j)
    i.negative? || i >= dna.size || j.negative? || j >= dna.size
  end

  def found_all_consecutive_characters?(count)
    count == CONSECUTIVE_CHARACTERS_FOR_MUTANCY - 1
  end

  def equal_characters_in_grid?(current_i, current_j, next_i, next_j)
    dna[current_i].at(current_j) == dna[next_i].at(next_j)
  end
end
