require 'rails_helper'

RSpec.describe Operator, type: :model do
  it { should have_many(:machines).dependent(:destroy) }
end