FactoryBot.define do
  factory :person do
    dna { Faker::Lorem.characters(36).scan(/.{6}/) }
  end
end
