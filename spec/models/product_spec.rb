require 'rails_helper'

RSpec.describe Product, type: :model do
  it { should belong_to(:machine) }
  it { should have_one(:tracker) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:current_inventory_count) }
  it { should validate_presence_of(:max_inventory_count) }
  it { should validate_presence_of(:threshold) }
end