module RescueFromRecordNotFound
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      redirect_to "/", notice: e.message
    end
  end
end