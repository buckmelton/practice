RSpec.describe Appointment do

  it "creates an appointment" do
    expect { FactoryBot.create(:appointment) }.to change(Appointment, :count).by(1)
  end

  let!(:doc1) { FactoryBot.create(:doctor) }
  let!(:pat1) { FactoryBot.create(:patient, doctor: doc1) }
  let!(:appt1) { FactoryBot.create(:appointment, doctor: doc1, patient: pat1, start_time: Time.current, duration_in_minutes: 50) }

  it "prevents overlapping appointments" do
    appt = Appointment.new(doctor_id: doc1.id, patient_id: pat1.id, start_time: Time.current, duration_in_minutes: 50 )
    
    expect(appt).not_to be_valid
  end
end
