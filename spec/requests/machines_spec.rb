require 'rails_helper'

RSpec.describe 'Machines API', type: :request do
  let!(:machines) { create_list(:machine, 10) }
  let(:machine_id) { machines.first.id }
  let(:operator_id) { 1 }
  
  describe 'GET /api/machines' do
    before { get '/api/machines', params = { :operator_id => operator_id } }

    it 'returns machines' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /api/machines/:id' do
    before { get "/api/machines/#{machine_id}" }

    context 'when the record exists' do
      it 'returns the machine' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(machine_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:machine_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Machine/)
      end
    end
  end

  # Test suite for POST /machines
  describe 'POST /api/machines' do
    let(:valid_attributes) { { :latitude => 40.60000, :longitude => -74.08089 } }

    context 'when the request is valid' do
      before { post '/api/machines', params = valid_attributes }

      it 'creates a machine' do
        expect(json['latitude']).to eq(40.60000)
        expect(json['longitude']).to eq(-74.08089)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/machines', params = { latitude: 40.60000 } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Longitude can't be blank/)
      end
    end
  end

  # Test suite for PUT /machines/:id
  describe 'PUT /api/machines/:id' do
    let(:valid_attributes) { { longitude: 40.6643 } }

    context 'when the record exists' do
      before { put "/api/machines/#{machine_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /machines/:id
  describe 'DELETE /api/machines/:id' do
    before { delete "/api/machines/#{machine_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end