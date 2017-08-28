require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "name" do
    before do
      @user = User.create(
        first_name: "Joe",
        last_name:  "Tester",
        email:      "joetester@example.com",
        password:   "dottle-nouveau-pavilion-tights-furze"
      )
      
      @user.projects.create(name: "Test Project")
    end
    
    it "is not allowed to be duplicated across projects per user" do
      new_project = @user.projects.build(name: "Test Project")
      
      new_project.valid?
      expect(new_project.errors[:name]).to include("has already been taken")
    end
    
    it "is allowed to be shared between two users" do
      other_user = User.create(
        first_name: "Jane",
        last_name:  "Tester",
        email:      "janetester@example.com",
        password:   "dottle-nouveau-pavilion-tights-furze"
      )
      
      other_project = other_user.projects.build(name: "Test Project")
      
      expect(other_project).to be_valid
    end
  end
end
