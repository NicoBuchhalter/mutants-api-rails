require 'rails_helper'

describe PeopleController, type: :controller do
  let!(:non_mutant_dna) { %w[ATGCGA CAGTGC TTATTT AGACGG GCGCTA TCACTG] }
  let!(:mutant_dna) { %w[ATGCGA CAGTGC TTATGT AGAAGG CCCCTA TCACTG] }
  let!(:mutant_dna_2) { %w[CTGCCA CAGTGC TTATGT AGAAGG CCCCTA TCACTG] }
  let!(:mutant_dna_3) { %w[ATGCGA CAGGGC TTGTTT AGACGG GCGCTA TCACTG] }

  describe 'POST #mutant' do
    context 'When creating a mutant' do
      let!(:mutant_params) { { dna: mutant_dna } }
      context 'and it already exists' do
        let!(:existing_mutant) { create(:person, dna: mutant_dna) }
        it 'does not create a new person' do
          expect { post :mutant, params: mutant_params }.not_to change(Person, :count)
        end

        it 'responds with 200 ok' do
          post :mutant, params: mutant_params
          expect(response).to have_http_status :ok
        end
      end

      context 'and it does not exist yet' do
        it 'creates a new person' do
          expect { post :mutant, params: mutant_params }.to change(Person, :count).by(1)
        end

        it 'responds with 200 ok' do
          post :mutant, params: mutant_params
          expect(response).to have_http_status :ok
        end
      end
    end

    context 'When creating a non mutant person' do
      let!(:non_mutant_params) { { dna: non_mutant_dna } }
      context 'and it already exists' do
        let!(:existing_mutant) { create(:person, dna: non_mutant_dna) }
        it 'does not create a new person' do
          expect { post :mutant, params: non_mutant_params }.not_to change(Person, :count)
        end

        it 'responds with 403 forbidden' do
          post :mutant, params: non_mutant_params
          expect(response).to have_http_status :forbidden
        end
      end

      context 'and it does not exist yet' do
        it 'creates a new person' do
          expect { post :mutant, params: non_mutant_params }.to change(Person, :count).by(1)
        end

        it 'responds with 403 forbidden' do
          post :mutant, params: non_mutant_params
          expect(response).to have_http_status :forbidden
        end
      end
    end

    context 'When dna is not valid' do
      let!(:invalid_dna_params) { { dna: Faker::Lorem.characters(36).scan(/.{8}/) } }

      it 'responds with an error message' do
        post :mutant, params: invalid_dna_params
        expect(response_body['error']).to eq 'Must provide a valid NxN DNA'
      end

      it 'responds with 402 unprocessable entity' do
        post :mutant, params: invalid_dna_params
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'does not create a new person' do
        expect { post :mutant, params: invalid_dna_params }.not_to change(Person, :count)
      end
    end
  end

  describe '#GET stats' do
    let!(:mutant) { create(:person, dna: mutant_dna) }
    let!(:mutant_2) { create(:person, dna: mutant_dna_2) }
    let!(:mutant_3) { create(:person, dna: mutant_dna_3) }
    let!(:non_mutant) { create(:person, dna: non_mutant_dna) }

    context 'When asking for stats' do
      it 'responds with 200 ok' do
        get :stats
        expect(response).to have_http_status :ok
      end

      it 'responds with the correct stats as a json response' do
        get :stats
        expect(response_body).to eq('count_mutant_dna' => 3, 'count_human_dna' => 4, 'ratio' => 0.75)
      end
    end
  end
end
