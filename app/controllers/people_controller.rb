class PeopleController < ApplicationController
  def mutant
    person = Person.find_or_create_by(person_params)
    if person.valid?
      return head(person.mutant? ? :ok : :forbidden)
    end
    render json: { error: 'Must provide a valid NxN DNA' }, status: :unprocessable_entity
  end

  def stats
    render json: Person.stats
  end

  private

  def person_params
    params.require(:dna)
    params.permit(dna: [])
  end
end
