module Pincers::Support

  class HttpNavigator

    def initialize(_http_client)
      @client = _http_client
      @history = []
      @pointer = -1
    end

    def current_url
      if @pointer >= 0
        @history[@pointer].url
      else nil end
    end

    def refresh
      if @pointer >= 0
        navigate @history[@pointer]
      else nil end
    end

    def push(_request)
      @history.slice!(@pointer+1..-1)
      @history.push _request
      @pointer += 1
      navigate _request
    end

    def back(_times=1)
      # not sure about this: for now, back will stop at the first request
      if @pointer < 0
        nil
      elsif _times >= @pointer
        change_pointer 0
      else
        change_pointer @pointer - _times
      end
    end

    def forward(_times=1)
      max_pointer = @history.length - 1
      if _times >= max_pointer - @pointer
        change_pointer max_pointer
      else
        change_pointer @pointer + _times
      end
    end

  private

    def change_pointer(_new_pointer)
      if _new_pointer != @pointer
        @pointer = _new_pointer
        navigate @history[@pointer]
      else nil end
    end

    def navigate(_request)
      _request.execute @client
    end

  end
end
