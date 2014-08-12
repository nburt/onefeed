module Facebook
  class ProfilePictureResponse

    def initialize(response)
      @response = response
    end

    def url
      Oj.load(@response.body)["data"]["url"]
    end

  end
end