class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :patient

  scope :with_doctor_and_patient, -> { includes(:doctor, :patient) }  

  validates :start_time, presence: true
  validates :duration_in_minutes, presence: true, numericality: { only: :integer }

  validate :patient_belongs_to_doctor
  validate :doctor_is_available

  private

  def patient_belongs_to_doctor
    return if patient.blank? || doctor.blank?
    errors.add(:patient, "does not belong to doctor") if patient.doctor_id != doctor.id
  end

  def new_end_time
    start_time + duration_in_minutes.minutes
  end

  def doctor_is_available
    overlapping = Appointment
      .where(doctor_id: doctor_id)
      .where.not(id: id)
      .where(
        "start_time < ? AND start_time + (duration_in_minutes * interval '1 minute') > ?",
        new_end_time,
        start_time
      )

    errors.add(:start_time, "conflicts with an existing appointment for this doctor") if overlapping.exists?
  end
end
