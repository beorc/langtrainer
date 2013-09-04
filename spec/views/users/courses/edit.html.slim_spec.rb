require 'spec_helper'

describe "users/courses/edit" do
  before(:each) do
    @users_course = assign(:users_course, stub_model(Users::Course,
      :slug => "MyString",
      :title => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit users_course form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => users_courses_path(@users_course), :method => "post" do
      assert_select "input#users_course_slug", :name => "users_course[slug]"
      assert_select "input#users_course_title", :name => "users_course[title]"
      assert_select "textarea#users_course_description", :name => "users_course[description]"
    end
  end
end
