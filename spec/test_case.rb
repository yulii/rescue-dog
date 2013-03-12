class TestCase

  class Controller
    ERRORS = { NotFound: 404, ServerError: 500 }
    FORMATS = [Mime::Type.new("text/html", :html), Mime::Type.new("application/json", :json)]
  end 

end
