require 'rails_helper'

RSpec.describe 'products API' do
  # Initialize the test data
  let!(:machine) { create(:machine) }
  let!(:products) { create_list(:product, 6, machine_id: machine.id) }
  let(:machine_id) { machine.id }
  let(:id) { products.first.id }

  # Test suite for GET /api/machines/:machine_id/products
  describe 'GET /api/machines/:machine_id/products' do
    before { get "/api/machines/#{machine_id}/products" }

    context 'when machine exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all machine products' do
        expect(json.size).to eq(6)
      end
    end

    context 'when machine does not exist' do
      let(:machine_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Machine/)
      end
    end
  end

  # Test suite for GET /api/machines/:machine_id/products/:id
  describe 'GET /api/machines/:machine_id/products/:id' do
    before { get "/api/machines/#{machine_id}/products/#{id}" }

    context 'when machine product exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the product' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when machine product does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Product/)
      end
    end
  end

  # Test suite for PUT /api/machines/:machine_id/products
  describe 'POST /api/machines/:machine_id/products' do
    let(:valid_attributes) { { name: 'Bottles', current_inventory_count: 10, max_inventory_count: 10, threshold: 10 } }

    context 'when request attributes are valid' do
      before { post "/api/machines/#{machine_id}/products", params = valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/api/machines/#{machine_id}/products", params = {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed/)
      end
    end
  end

  # Test suite for PUT /api/machines/:machine_id/products/:id
  describe 'PUT /api/machines/:machine_id/products/:id' do
    let(:valid_attributes) { { name: 'Mozart' } }

    before { put "/api/machines/#{machine_id}/products/#{id}", params = valid_attributes }

    context 'when product exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the product' do
        expect(products.first.name).to match(/Mozart/)
      end
    end

    context 'when the product does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Product/)
      end
    end
  end

  # Test suite for DELETE /api/machines/:id
  describe 'DELETE /api/machines/:id' do
    before { delete "/api/machines/#{machine_id}/products/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end