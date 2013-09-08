class TestCase

  class Controller
    ERRORS = { BadRequest: 400, Unauthorized: 401, NotFound: 404, ServerError: 500 }
    FORMATS = [Mime::Type.new("text/html", :html), Mime::Type.new("application/json", :json)]

    RESCUE_OPTIONS = [
      [:create, :update]
    ]
  end 

end
