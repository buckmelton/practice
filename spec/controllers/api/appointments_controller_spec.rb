RSpec.describe Api::AppointmentsController do

  describe "#index" do
    let!(:doc1) { FactoryBot.create(:doctor) }
    let!(:pat1) { FactoryBot.create(:patient, doctor: doc1) }
    let!(:appt1) { FactoryBot.create(:appointment, doctor: doc1, patient: pat1) }

    it "returns json data" do
      get :index
      expect(response.status).to eq(200)

      res_appts = JSON.parse(response.body)
      expect(res_appts).to be_present
      expect(res_appts.length).to eq(1)
      res_appt = res_appts.first
      expect(res_appt["doctor"]["name"]).to eq(doc1.name)
      expect(res_appt["patient"]["name"]).to eq(pat1.name)
    end
  end
end
