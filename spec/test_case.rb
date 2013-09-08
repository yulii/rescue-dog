class TestCase

  class Controller
    ERRORS = { BadRequest: 400, Unauthorized: 401, NotFound: 404, ServerError: 500 }
    FORMATS = [Mime::Type.new("text/html", :html), Mime::Type.new("application/json", :json)]

    RESCUE_OPTIONS = [
      [:show],
      [:new, :show, :create],
      [:new, :show, :edit, :create, :update],
      [:new, :show, :edit, { create: {}, update: {}, delete: {} }],
    ]

    FLASHS = [:DefaultController, :RescueController, :RescueDogController]
  end 

end
