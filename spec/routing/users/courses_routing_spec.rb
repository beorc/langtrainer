require "spec_helper"

describe Users::CoursesController do
  describe "routing" do

    it "routes to #index" do
      get("/users/courses").should route_to("users/courses#index")
    end

    it "routes to #new" do
      get("/users/courses/new").should route_to("users/courses#new")
    end

    it "routes to #show" do
      get("/users/courses/1").should route_to("users/courses#show", :id => "1")
    end

    it "routes to #edit" do
      get("/users/courses/1/edit").should route_to("users/courses#edit", :id => "1")
    end

    it "routes to #create" do
      post("/users/courses").should route_to("users/courses#create")
    end

    it "routes to #update" do
      put("/users/courses/1").should route_to("users/courses#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/users/courses/1").should route_to("users/courses#destroy", :id => "1")
    end

  end
end
