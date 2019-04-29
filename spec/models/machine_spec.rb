require 'rails_helper'

RSpec.describe Machine, type: :model do
  it { should have_many(:products).dependent(:destroy) }
  it { should validate_presence_of(:latitude) }
  it { should validate_presence_of(:longitude) }
end