require 'rails_helper'

RSpec.describe "scientist show page" do 
  before :each do 
    @lab_1 = Lab.create!(name: "Fermilab") 

    @sci_1 = @lab_1.scientists.create!(name: "Marie Curie", specialty: "radioactivity", university: "University of Paris")
    @sci_2 = @lab_1.scientists.create!(name: "Katherine Johnson", specialty: "Mathematics/Space", university: "West Virginia State University")

    @exp_1 = Experiment.create!(name: "MINERvA", objective: "study neutrino reactions with 5 different nuclei", num_months: 4)
    @exp_2 = Experiment.create!(name: "Freedom 7", objective: "trajectory analysis", num_months: 10)

    @sci_exp_1 = ScientistExperiment.create!(scientist_id: @sci_1.id, experiment_id: @exp_1.id)
    @sci_exp_2 = ScientistExperiment.create!(scientist_id: @sci_2.id, experiment_id: @exp_1.id)

    @sci_exp_3 = ScientistExperiment.create!(scientist_id: @sci_2.id, experiment_id: @exp_2.id)
    @sci_exp_3 = ScientistExperiment.create!(scientist_id: @sci_1.id, experiment_id: @exp_2.id)
  end

  it "shows the scientists information and the experiments that they are running" do 
    visit scientist_path(@sci_1)

    within "#details" do 
      expect(page).to have_content("Name: #{@sci_1.name}")
      expect(page).to have_content("Specialty: #{@sci_1.specialty}")
      expect(page).to have_content("University: #{@sci_1.university}")
    end

    within "#lab" do 
      expect(page).to have_content("Lab: Fermilab")
    end

    within "#current_experiments" do 
      expect(page).to have_content("Name: MINERvA")
      expect(page).to have_content("Name: Freedom 7")
    end
  end

  it "has a remove button to remove an experiment from that specific scientists work load" do 
    visit scientist_path(@sci_1)

    within "#experiment-#{@exp_1.id}" do 
      expect(page).to have_button("Remove #{@exp_1.name}")
      click_button "Remove #{@exp_1.name}"
    end
    expect(current_path).to eq(scientist_path(@sci_1))

    within "#current_experiments" do 
      expect(page).to_not have_content("MINERvA")
    end

    visit scientist_path(@sci_2)

    within "#current_experiments" do 
      expect(page).to have_content("MINERvA")
    end
  end
end