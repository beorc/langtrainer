require 'spec_helper'

describe "users/courses/new" do
  before(:each) do
    assign(:users_course, stub_model(Users::Course,
      :slug => "MyString",
      :title => "MyString",
      :description => "MyText"
    ).as_new_record)
  end

  it "renders new users_course form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => users_courses_path, :method => "post" do
      assert_select "input#users_course_slug", :name => "users_course[slug]"
      assert_select "input#users_course_title", :name => "users_course[title]"
      assert_select "textarea#users_course_description", :name => "users_course[description]"
    end
  end
end
