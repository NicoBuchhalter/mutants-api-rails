class CreatePeople < ActiveRecord::Migration[5.1]
  def change
    create_table :people do |t|
      t.string :dna, array: true, unique: true, null: false, index: true
      t.boolean :mutant, default: false, index: true

      t.timestamps
    end
  end
end
