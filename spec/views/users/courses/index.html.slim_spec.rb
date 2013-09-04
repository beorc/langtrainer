require 'spec_helper'

describe "users/courses/index" do
  before(:each) do
    assign(:users_courses, [
      stub_model(Users::Course,
        :slug => "Slug",
        :title => "Title",
        :description => "MyText"
      ),
      stub_model(Users::Course,
        :slug => "Slug",
        :title => "Title",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of users/courses" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Slug".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
