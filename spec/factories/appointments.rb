FactoryBot.define do
  factory :appointment do
    doctor { create(:doctor) }
    patient { create(:patient, doctor: doctor) }
    start_time { Time.zone.now }
    duration_in_minutes { 50 }
  end
end
