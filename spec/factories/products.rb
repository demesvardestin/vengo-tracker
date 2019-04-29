FactoryBot.define do
    count = Faker::Number.number(2)
    factory :product do
        name "Mozart" # arbitrary. should fix that at some point
        current_inventory_count count
        max_inventory_count count
        threshold count
    end
end