module Rescue
  class ApplicationError < StandardError

    STATUS_CODES = {
      40  => { http: 400, status: 'Invalid Request'     },
      49  => { http: 400, status: 'Unsupported'         },
      81  => { http: 401, status: 'Access Denied'       },
      83  => { http: 401, status: 'Expired Token'       },
      98  => { http: 403, status: 'Not Permitted'       },
      99  => { http: 403, status: 'Suspended Account'   },
      121 => { http: 410, status: 'Deleted Resources'   },
      140 => { http: 429, status: 'Rate Limit Exceeded' },
      210 => { http: 500, status: 'Internal Error'      },
      230 => { http: 503, status: 'Over Capacity'       },
    }

    attr_accessor :code
    attr_accessor :stauts

    def initialize code, status, message = nil
      @code    = code
      @status  = (message ? status : STATUS_CODES[code][:status])
      @message = message
    end

  end
end
