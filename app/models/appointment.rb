class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :patient

  validates :start_time, presence: true
  validates :duration_in_minutes, presence: true, numericality: { only: :integer }

  validate :patient_belongs_to_doctor

  private

  def patient_belongs_to_doctor
    return if patient.blank? || doctor.blank?

    errors.add(:patient, "does not belong to doctor") if patient.doctor_id != doctor.id
  end
end
