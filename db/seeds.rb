# TODO: Seed the database according to the following requirements:
# - There should be 10 Doctors with unique names
# - Each doctor should have 10 patients with unique names
# - Each patient should have 10 appointments (5 in the past, 5 in the future)
#   - Each appointment should be 50 minutes in duration

DOCTOR_COUNT = 10
PATIENTS_PER_DOCTOR = 10
PAST_APPOINTMENTS_PER_PATIENT = 5
FUTURE_APPOINTMENTS_PER_PATIENT = 5

Appointment.delete_all
Patient.delete_all
Doctor.delete_all

DOCTOR_COUNT.times do
  doctor = Doctor.create!(
    name: Faker::Name.name
  )

  PATIENTS_PER_DOCTOR.times do
    patient = doctor.patients.create!(
      name: Faker::Name.name
    )

    # past appointments
    5.times do |k|
      patient.appointments.create!(
        doctor: patient.doctor,
        duration_in_minutes: 50,
        start_time: Time.current - k.weeks - 1
      )
    end

    # future appointments
    5.times do |k|
      patient.appointments.create!(
        doctor: patient.doctor,
        duration_in_minutes: 50,
        start_time: Time.current + k.weeks
      )
    end
  end
end