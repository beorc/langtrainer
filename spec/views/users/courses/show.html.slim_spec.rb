require 'spec_helper'

describe "users/courses/show" do
  before(:each) do
    @users_course = assign(:users_course, stub_model(Users::Course,
      :slug => "Slug",
      :title => "Title",
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Slug/)
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
  end
end
