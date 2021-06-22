puts '=' * 30
puts 'Creating users'
puts '=' * 30

User.create!(
  email: 'test@test.com',
  password: '123123',
  first_name: 'John',
  last_name: 'Doe',
  birth_date: Date.new(2001, 0o1, 0o1),
  cpf: '12123123123',
  phone: '(11) 9876-5432',
  address: 'Rua Jericó, 193, São Paulo, SP',
  admin: false
)

user = User.create!(
  email: 'admin@test.com',
  password: '123123',
  first_name: 'Jane',
  last_name: 'Doe',
  birth_date: Date.new(2001, 0o1, 0o1),
  cpf: '32321321321',
  phone: '(11) 9678-2345',
  address: 'Ladeira da Glória, 26, Rio de Janeiro, RJ',
  admin: true
)

puts 'Admin - email: admin@test.com, password: 123123'
puts 'Normal user - email: test@test.com, password: 123123'

puts ''
puts '=' * 30
puts 'Creating box items'
puts '=' * 30

happy_hour = %w[Vinhos Cervejas Destilados Sucos Refrigerantes]
beleza_cuidado = %w[Skincare\ Rosto Skincare\ Corpo Cabelo Esmaltaria]
receita_certa = %w[Aves Bovinos Peixe Vegano Vegetariano Sobremesa]

puts ''
puts 'Box Happy Hour'
puts '-' * 30

happy_hour.each do |item|
  BoxItem.create!(
    box_name: 'Happy Hour',
    item_name: item
  )
  puts "<<- #{item}"
end

puts ''
puts 'Box Beleza e Cuidado'
puts '-' * 30

beleza_cuidado.each do |item|
  BoxItem.create!(
    box_name: 'Beleza e Cuidado',
    item_name: item
  )
  puts "<<- #{item}"
end

puts ''
puts 'Box Receita Certa'
puts '-' * 30

receita_certa.each do |item|
  BoxItem.create!(
    box_name: 'Receita Certa',
    item_name: item
  )
  puts "<<- #{item}"
end

puts ''
puts '=' * 30
puts 'Creating plans'
puts '=' * 30

3.times do
  Plan.create!(
    user: user,
    carrefour_card: [true, false].sample,
    category: Plan::CATEGORIES.keys.sample,
    auto_renew: true,
    quantity: rand(1..3),
    ship_day: Plan::SHIP_DAYS.sample
  )
end

puts "#{Plan.count} plans created..."

puts ''
puts '=' * 30
puts 'Creating shipments'
puts '=' * 30

6.times do
  shipment = Shipment.create!(
    plan: Plan.all.sample
  )
  puts "Created shipment '#{shipment.shipping_code}'"
end

puts ''
puts 'Seeding done!'
