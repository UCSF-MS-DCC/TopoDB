class ErrorController < ApplicationController
  def error_404
    render 'error/not_found'
  end
end