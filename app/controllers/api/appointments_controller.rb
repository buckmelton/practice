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

    if index_params[:upcoming]
      @appointments = @appointments.order(:start_time)
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
    @new_appt = Appointment.new(create_params)

    if @new_appt.save
      render json: @new_appt, status: :created
    else
      render json: @new_appt.errors, status: :unprocessable_entity
    end
  end

  private

  def index_params
    params.permit(:doctor_id, :start_date, :end_date)
  end

  def create_params
    params.require(:appointment).permit(:doctor_id, :patient_id, :start_time, :duration)
  end
end
