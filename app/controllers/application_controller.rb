# frozen_string_literal: true

class ApplicationController < ActionController::API
  protected

  def render_json(status, json = {})
    render json:, status:
  end
end
