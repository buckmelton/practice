RSpec.describe Api::AppointmentsController do

  let!(:doc1) { FactoryBot.create(:doctor) }
  let!(:pat1) { FactoryBot.create(:patient, doctor: doc1) }
  let!(:appt1) { FactoryBot.create(:appointment, doctor: doc1, patient: pat1, start_time: Time.current) }

  let!(:doc2) { FactoryBot.create(:doctor) }
  let!(:pat2) { FactoryBot.create(:patient, doctor: doc2) }
  let!(:appt2) { FactoryBot.create(:appointment, doctor: doc2, patient: pat2, start_time: Time.current + 7.days) }

  describe "#index" do
    context "when no filters provided" do
      it "returns all appointments as json" do
        get :index
        expect(response.status).to eq(200)

        res_appts = JSON.parse(response.body)
        expect(res_appts).to be_present
        expect(res_appts.length).to eq(2)
        res_appt = res_appts.first
        expect(res_appt["doctor"]["name"]).to eq(doc1.name)
        expect(res_appt["patient"]["name"]).to eq(pat1.name)
      end
    end

    context "when filters provided" do
      it "filters on doctor" do
        get :index, params: { doctor_id: doc2.id }

        expect(response.status).to eq(200)

        res_appts = JSON.parse(response.body)
        expect(res_appts).to be_present
        expect(res_appts.length).to eq(1)
        res_appt = res_appts.first
        expect(res_appt["doctor"]["name"]).to eq(doc2.name)
        expect(res_appt["patient"]["name"]).to eq(pat2.name)
      end
    end

    context "when date range is provided" do
      it "filters on date range" do
        get :index, params: { start_date: Time.current + 3.days, end_date: Time.current + 8.days }

        expect(response.status).to eq(200)

        res_appts = JSON.parse(response.body)
        expect(res_appts).to be_present
        expect(res_appts.length).to eq(1)
        res_appt = res_appts.first
        expect(res_appt["doctor"]["name"]).to eq(doc2.name)
        expect(res_appt["patient"]["name"]).to eq(pat2.name)
      end
    end
  end

  describe "#create" do
    it "creates a new appointment" do
      expect {
        post :create, params: { appointment: { doctor_id: doc1.id, patient_id: pat1.id, start_time: Time.current, duration_in_minutes: 50 } }
    }.to change(Appointment, :count).by(1)
    end
  end
end
