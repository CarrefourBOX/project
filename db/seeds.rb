puts '=' * 30
puts 'Cleaning DB...'
puts '=' * 30

Shipment.delete_all
Box.delete_all
BoxItem.delete_all
BoxName.delete_all
Plan.delete_all
User.delete_all

puts ''

puts '=' * 30
puts 'Creating users'
puts '=' * 30

user = User.create!(
  email: 'test@test.com',
  password: 'senha123',
  first_name: 'John',
  last_name: 'Doe',
  birth_date: Date.new(2001, 0o1, 0o1),
  cpf: '12123123123',
  phone: '(11) 9876-5432',
  address: 'Rua Jericó, 193, São Paulo, SP',
  admin: false
)

User.create!(
  email: 'admin@test.com',
  password: 'senha123',
  first_name: 'Jane',
  last_name: 'Doe',
  birth_date: Date.new(2001, 0o1, 0o1),
  cpf: '32321321321',
  phone: '(11) 9678-2345',
  address: 'Ladeira da Glória, 26, Rio de Janeiro, RJ',
  admin: true
)

puts ''
puts '=' * 30
puts 'Creating box names'
puts '=' * 30

box1 = BoxName.create!(
  name: 'Happy Hour',
  description: 'Receba em sua casa um KIT para curtir um momento de distração, com bebidas, salgados e aperitivos.',
  color: '#7A0997'
)
puts "#{box1.name} Box created!"
box2 = BoxName.create!(
  name: 'Beleza e Cuidado',
  description: 'Que tal cuidar da sua beleza? Com o Box Beleza & Cuidado nunca foi tão facil e prático cuidar de você',
  color: '#E1357D'
)
puts "#{box2.name} Box created!"
box3 = BoxName.create!(
  name: 'Receita Certa',
  description: 'Receba em sua residência todas os ingredientes para preparar sua receita diferente,tendo momentos agradáveis com seus familiares',
  color: '#05977D'
)
puts "#{box3.name} Box created!"

puts ''
puts '=' * 30
puts 'Creating box items'
puts '=' * 30

happy_hour = %w[Vinhos Cervejas Destilados Sucos Refrigerantes]
beleza_cuidado = %w[Skincare\ Rosto Skincare\ Corpo Cabelo Esmaltaria]
receita_certa = %w[Aves Bovinos Peixe Vegano Vegetariano Sobremesa]

puts ''
puts "Box #{box1.name}"
puts '-' * 30

happy_hour.each do |item|
  BoxItem.create!(
    box_name: box1.name,
    item_name: item
  )
  puts "<<- #{item}"
end

puts ''
puts "Box #{box2.name}"
puts '-' * 30

beleza_cuidado.each do |item|
  BoxItem.create!(
    box_name: box2.name,
    item_name: item
  )
  puts "<<- #{item}"
end

puts ''
puts "Box #{box3.name}"
puts '-' * 30

receita_certa.each do |item|
  BoxItem.create!(
    box_name: box3.name,
    item_name: item
  )
  puts "<<- #{item}"
end

puts ''
puts '=' * 30
puts 'Creating plans'
puts '=' * 30

3.times do
  plan = Plan.create!(
    user: user,
    carrefour_card: [true, false].sample,
    category: Plan::CATEGORIES.keys.sample,
    auto_renew: true,
    quantity: rand(1..3),
    ship_day: Plan::SHIP_DAYS.sample
  )

  boxes = BoxName.all.sample(rand(1..3))
  boxes.each do |box|
    items = BoxItem.where(box_name: box.name).sample(rand(1..4))
    items.each { |item| Box.create!(box_item: item, plan: plan) }
  end
end

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
puts '=' * 30
puts "#{User.count} users created..."
puts 'Admin - email: admin@test.com, password: senha123'
puts 'Normal user - email: test@test.com, password: senha123'
puts '-' * 30
puts "#{Plan.count} plans created..."
puts '-' * 30
puts "#{BoxName.count} boxes created..."
puts '-' * 30
puts "#{Shipment.count} shipments created..."

puts ''
puts 'Seeding done!'
