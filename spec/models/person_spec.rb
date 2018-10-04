require 'rails_helper'

describe Person, type: :model do
  it { is_expected.to validate_presence_of(:dna) }
  it { is_expected.to validate_uniqueness_of(:dna) }

  subject(:person) { build(:person) }

  let!(:non_mutant_dna) { %w[ATGCGA CAGTGC TTATTT AGACGG GCGCTA TCACTG] }
  let!(:mutant_dna) { %w[ATGCGA CAGTGC TTATGT AGAAGG CCCCTA TCACTG] }
  let!(:mutant_dna_2) { %w[CTGCCA CAGTGC TTATGT AGAAGG CCCCTA TCACTG] }
  let!(:mutant_dna_3) { %w[ATGCGA CAGGGC TTGTTT AGACGG GCGCTA TCACTG] }

  describe 'When creating a person' do
    context 'and dna is an array of N strings with N length' do
      it { is_expected.to be_valid }
    end

    context 'and dna is not an array of N strings with N length' do
      subject (:person) { build(:person, dna: Faker::Lorem.characters(36).scan(/.{8}/)) }
      it { is_expected.not_to be_valid }
    end

    context 'and it has a non-mutant dna' do
      subject (:person) { create(:person, dna: non_mutant_dna) }
      it { is_expected.to have_attributes(mutant: false) }
    end

    context 'and it has a mutant dna' do
      subject (:person) { create(:person, dna: mutant_dna) }
      it { is_expected.to have_attributes(mutant: true) }
    end
  end

  describe "When asking for people's stats" do
    let!(:mutant) { create(:person, dna: mutant_dna) }
    let!(:mutant_2) { create(:person, dna: mutant_dna_2) }
    let!(:mutant_3) { create(:person, dna: mutant_dna_3) }
    let!(:non_mutant) { create(:person, dna: non_mutant_dna) }

    it 'responds with the correct hash' do
      expect(described_class.stats).to eq(count_mutant_dna: 3, count_human_dna: 4, ratio: 0.75)
    end
  end
end
