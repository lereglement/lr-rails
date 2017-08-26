# encoding: utf-8
class Landing::RootController < Landing::BaseController
  def index
    render :'landing/index'
  end
end
