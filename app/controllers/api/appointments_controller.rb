class Api::AppointmentsController < ApplicationController
  def index
    # TODO: return all values
    @appts = Appointment.includes(:doctor, :patient)
    render json: @appts, include:
      {
        doctor: { only: [:id, :name] },
        patient: { only: [:id, :name] }
      }
    # TODO: return filtered values
    # head :ok
  end

  def create
    # TODO:
  end
end
