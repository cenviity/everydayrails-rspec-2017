require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @user = User.create(
        first_name: "Joe",
        last_name:  "Tester",
        email:      "joetester@example.com",
        password:   "dottle-nouveau-pavilion-tights-furze"
    )
  end
  
  it "is valid with a name and owner" do
    project = Project.new(
      name: "Test Project",
      owner: @user
    )
    
    expect(project).to be_valid
  end
  
  it "is invalid without a name" do
    project = Project.new(name: nil)
    
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end
  
  it "is invalid without an owner" do
    project = Project.new(owner: nil)
    
    project.valid?
    expect(project.errors[:owner]).to include("must exist")
  end
  
  describe "name" do
    before do
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
  
  describe "#late?" do
    before do
      @project = Project.new(
        name: "Test Project",
        owner: @user
      )
    end
    
    it "returns true if due date is earlier than today" do
      @project.due_on = Date.today - 1
      
      expect(@project.late?).to be true
    end
    
    it "returns false if due date is today" do
      @project.due_on = Date.today
      
      expect(@project.late?).to be false
    end
    
    it "returns false if due date is later than today" do
      @project.due_on = Date.today + 1
      
      expect(@project.late?).to be false
    end
  end
end
