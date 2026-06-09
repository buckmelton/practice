class Api::AppointmentsController < ApplicationController
  def index
    # TODO: return all values
    @appts = Appointment.includes(:doctor, :patient)

    # TODO: return filtered values
    if index_params[:doctor_id].present?
      @appts = @appts.where(doctor_id: index_params[:doctor_id])
    end

    if index_params[:start_date].present? && index_params[:end_date].present?
      @appts = @appts.where(start_time: Time.zone.parse(params[:start_date])..Time.zone.parse(params[:end_date]))
    end

    render json: @appts, include:
      {
        doctor: { only: [:id, :name] },
        patient: { only: [:id, :name] }
      }
    # head :ok
  end

  def create
    # TODO:
  end

  private

  def index_params
    params.permit(:doctor_id, :start_date, :end_date)
  end
end
