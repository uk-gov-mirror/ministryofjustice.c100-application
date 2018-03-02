module Users
  class DraftsController < ApplicationController
    before_action :authenticate_user!

    def index
      @drafts = []
    end
  end
end
