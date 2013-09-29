class PublicController < ApplicationController
  def index
    @title = "Better Error Page test"
  end

  def test_function
    a = 1
    b = 2
    c = a + b
    b = 12
    c = "steve" 
    d = [20,30]

    d = 40
    render json: {success: true, numbers: d.join(" ")}
  end
end
