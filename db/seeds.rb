puts '=' * 30
puts 'Cleaning DB...'
puts '=' * 30

Review.delete_all
Shipment.delete_all
Box.delete_all
BoxItem.delete_all
CarrefourBox.delete_all
Order.delete_all
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

admin = User.create!(
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
puts 'Creating Carrefour Boxes'
puts '=' * 30

icon_urls = [
  'https://res.cloudinary.com/dezlaawpu/image/upload/v1624482281/carrefour_box/happy-hour.png',
  'https://res.cloudinary.com/dezlaawpu/image/upload/v1624482281/carrefour_box/beleza-e-cuidado.png',
  'https://res.cloudinary.com/dezlaawpu/image/upload/v1624482281/carrefour_box/receita-certa.png'
]

box1 = CarrefourBox.create!(
  name: 'Happy Hour',
  description: 'Receba em sua casa um KIT para curtir um momento de distração, com bebidas, salgados e aperitivos.',
  color: '#7A0997',
  plans: {
    'Mensal' => { 'price' => 9990 },
    'Trimestral' => { 'price' => 8990 },
    'Semestral' => { 'price' => 7990 },
    'Anual' => { 'price' => 6990 }
  }
)
box1_icon = URI.open(icon_urls[0])
box1.icon.attach(
  io: box1_icon,
  filename: "box#{box1.id}-icon.jpg",
  content_type: 'image/png'
)
puts "#{box1.name} Box created!"

box2 = CarrefourBox.create!(
  name: 'Beleza e Cuidado',
  description: 'Que tal cuidar da sua beleza? Com o Box Beleza & Cuidado nunca foi tão facil e prático cuidar de você',
  color: '#E1357D',
  plans: {
    'Mensal' => { 'price' => 9990 },
    'Trimestral' => { 'price' => 8990 },
    'Semestral' => { 'price' => 7990 },
    'Anual' => { 'price' => 6990 }
  }
)
box2_icon = URI.open(icon_urls[1])
box2.icon.attach(
  io: box2_icon,
  filename: "box#{box2.id}-icon.jpg",
  content_type: 'image/png'
)
puts "#{box2.name} Box created!"

box3 = CarrefourBox.create!(
  name: 'Receita Certa',
  description: 'Receba em sua residência todas os ingredientes para preparar sua receita diferente, tendo momentos agradáveis com seus familiares',
  color: '#05977D',
  plans: {
    'Mensal' => { 'price' => 9990 },
    'Trimestral' => { 'price' => 8990 },
    'Semestral' => { 'price' => 7990 },
    'Anual' => { 'price' => 6990 }
  }
)
box3_icon = URI.open(icon_urls[2])
box3.icon.attach(
  io: box3_icon,
  filename: "box#{box3.id}-icon.jpg",
  content_type: 'image/png'
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
    carrefour_box: box1,
    name: item
  )
  puts "<<- #{item}"
end

puts ''
puts "Box #{box2.name}"
puts '-' * 30

beleza_cuidado.each do |item|
  BoxItem.create!(
    carrefour_box: box2,
    name: item
  )
  puts "<<- #{item}"
end

puts ''
puts "Box #{box3.name}"
puts '-' * 30

receita_certa.each do |item|
  BoxItem.create!(
    carrefour_box: box3,
    name: item
  )
  puts "<<- #{item}"
end

puts ''
puts '=' * 30
puts 'Creating plans'
puts '=' * 30

num_of_shipments = { 'Mensal' => 1, 'Trimestral' => 3, 'Semestral' => 6, 'Anual' => 12 }

3.times do
  boxes = CarrefourBox.all.sample(rand(1..3))
  plan = Plan.create!(
    user: user,
    carrefour_card: [true, false].sample,
    category: Plan::CATEGORIES.keys.sample,
    auto_renew: true,
    quantity: boxes.size,
    created_at: rand(30..133).days.ago
  )
  plan.update(active: plan.expires_at > Time.now)

  boxes.each do |box|
    items = box.box_items.sample(rand(1..4))
    items.each { |item| Box.create!(box_item: item, plan: plan) }
  end

  plan.calculate_total

  Order.create!(plan: plan, amount: plan.price, status: 'complete', user: user, created_at: plan.created_at)

  puts ''
  puts '-' * 30
  puts %(
Created a #{plan.category} Plan on #{plan.created_at.strftime('%d/%m/%Y')}, for R$#{plan.price_cents / 100.to_f},
with #{plan.boxes.map { |box| "BOX #{box.box_item.carrefour_box.name}" }.uniq.join(', ')}.
  )

  days_till_ship = plan.ship_day.to_i - plan.created_at.day
  num_of_shipments[plan.category].times do |i|
    ship_date = Time.at(plan.created_at + i.months) + days_till_ship.days
    break if ship_date > Time.now

    shipment = Shipment.create!(
      plan: plan,
      created_at: ship_date
    )
    puts "- Sent a shipment on #{shipment.created_at.strftime('%d/%m/%Y')}, code: '#{shipment.shipping_code}' "
  end
end

puts ''
puts '=' * 30

review = Review.create!(
  user: user,
  carrefour_box: box1,
  content: "Ótimos produtos, preços e entregas",
  rating: 4,
)

review = Review.create!(
  user: user,
  carrefour_box: box2,
  content: "Adorei os produtos e descobri novas marcas e gostos que nunca iria experimentar",
  rating: 5,
)

review = Review.create!(
  user: admin,
  carrefour_box: box2,
  content: "Preço justo, entrega na quantidade perfeita e ótima qualidade",
  rating: 4,
)

puts "#{Review.count} Reviews created..."

puts ''
puts '=' * 30
puts "#{User.count} users created..."
puts 'Admin - email: admin@test.com, password: senha123'
puts 'Normal user - email: test@test.com, password: senha123'
puts '-' * 30
puts "#{Plan.count} plans created..."
puts '-' * 30
puts "#{CarrefourBox.count} boxes created..."
puts '-' * 30
puts "#{Shipment.count} shipments created..."

puts ''
puts 'Seeding done!'
