puts '=' * 30
puts 'Cleaning DB...'
puts '=' * 30

Review.delete_all
Shipment.delete_all
Box.delete_all
BoxItem.delete_all
Review.delete_all
CarrefourBox.delete_all
Order.delete_all
Plan.delete_all
Address.delete_all
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
  cpf: '61132741017',
  phone: '(11) 9876-5432',
  admin: false
)

Address.create!(
  user: user,
  name: 'casa',
  cep: '05435-040',
  street: 'Rua Jericó',
  number: '193',
  state: 'SP',
  city: 'São Paulo',
  main: true
)

admin_user = User.create!(
  email: 'admin@test.com',
  password: 'senha123',
  first_name: 'Jane',
  last_name: 'Doe',
  birth_date: Date.new(2001, 0o1, 0o1),
  cpf: '85574090015',
  phone: '(11) 9678-2345',
  admin: true
)

Address.create!(
  user: admin_user,
  name: 'casa',
  cep: '22211-120',
  street: 'Ladeira da Glória',
  number: '26',
  state: 'RJ',
  city: 'Rio de Janeiro',
  main: true
)

puts ''
puts '=' * 30
puts 'Creating Fake users'
puts '=' * 30

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
  summary: 'Receba em sua casa um KIT para curtir um momento de distração, com bebidas, salgados e aperitivos.',
  description: 'Precisando encontrar um tempo para você? Adquirindo o BOX Happy Hour você receberá ítens da sua preferência como: cervejas, vinhos, destilados, sucos, diversos aperitivos e comidas da melhor qualidade, para unir seus amigos e familiares e curtir um momento de risadas e descontração no conforto de seu lar.',
  color: '#7A0997',
  plans: {
    'P' => { 'price' => 7990 },
    'M' => { 'price' => 9990 },
    'G' => { 'price' => 11990 }
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
  summary: 'Que tal cuidar da sua beleza? Com o Box Beleza & Cuidado nunca foi tão facil e prático cuidar de você',
  description: 'Que tal cuidar de você e da sua beleza? Adquirindo o BOX Beleza e Cuidado você receberá itens da sua preferência como hidratantes, esmaltes, esfoliante corporais, entre outros produtos para ajudar na sua rotina de autocuidado.',
  color: '#E1357D',
  plans: {
    'P' => { 'price' => 7990 },
    'M' => { 'price' => 9990 },
    'G' => { 'price' => 11990 }
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
  summary: 'Receba em sua residência todas os ingredientes para preparar sua receita diferente, tendo momentos agradáveis com seus familiares',
  description: 'Sabe cozinhar? Chegou o momento de se aventurar. Adquirindo o Box Receita Certa, você irá receber em sua residência todos os ingredientes para iniciar suas aventuras na cozinha, desenvolver suas habilidades culinárias e preparar uma nova receita em um momento ou uma data especial. E você ainda pode selecionar os itens de sua preferência como aves, bovinos, peixes, sobremesas entre outros.',
  color: '#05977D',
  plans: {
    'P' => { 'price' => 7990 },
    'M' => { 'price' => 9990 },
    'G' => { 'price' => 11990 }
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
puts 'Creating test user plan'
puts '=' * 30

boxes = CarrefourBox.all.sample(rand(2..3))
plan = Plan.create!(
  user: user,
  quantity: boxes.size,
  address: user.addresses.first,
  carrefour_card: false,
  active: true,
  created_at: rand(30..133).days.ago
)

boxes.each do |box|
  box_size = Box::BOX_SIZES.sample
  items = box.box_items.sample(rand(1..4))
  items.each { |item| Box.create!(box_item: item, plan: plan, box_size: box_size) }
end

plan.calculate_total

Order.create!(plan: plan, amount: plan.total_price, status: 'complete', user: user, created_at: plan.created_at)

puts ''
puts '-' * 30
puts %(
Created a plan on #{plan.created_at.strftime('%d/%m/%Y')}, for R$#{plan.price_cents / 100.to_f},
with #{plan.boxes.map { |box| "BOX #{box.box_item.carrefour_box.name}" }.uniq.join(', ')}.
  )

days_till_ship = plan.ship_day - plan.created_at.day
ship_date = plan.created_at + days_till_ship.days

loop do
  shipment = Shipment.create!(
    plan: plan,
    created_at: ship_date,
    shipping_cost: plan.shipment
  )
  puts "- Sent a shipment on #{shipment.created_at.strftime('%d/%m/%Y')}, code: '#{shipment.shipping_code}' "
  ship_date += 1.month
  break unless plan.active && ship_date < Time.now
end

puts ''
puts 'Creating fake users and plans'
puts '=' * 30
FakeUserGenerator.generate_fake_users

Review.create!(
  user: User.all.sample,
  carrefour_box: box1,
  content: 'Amei o produto, ansiosa pela próxima entrega.',
  rating: 5
)

Review.create!(
  user: User.all.sample,
  carrefour_box: box1,
  content: 'Gostei dos produtos, mas a cerveja era de trigo.',
  rating: 3
)

Review.create!(
  user: User.all.sample,
  carrefour_box: box1,
  content: 'Ótima experiência, produtos bem selecionados',
  rating: 4
)

Review.create!(
  user: User.all.sample,
  carrefour_box: box1,
  content: 'Adorei tudo. BOX aprovado.',
  rating: 4
)

Review.create!(
  user: User.all.sample,
  carrefour_box: box1,
  content: 'Adorei, até alterei o tamanho para vir mais itens.',
  rating: 5
)

Review.create!(
  user: User.all.sample,
  carrefour_box: box2,
  content: 'Adorei os produtos, vou usar todos com certeza.',
  rating: 5
)

Review.create!(
  user: User.all.sample,
  carrefour_box: box2,
  content: 'Amei os produtos.',
  rating: 5
)

Review.create!(
  user: User.all.sample,
  carrefour_box: box2,
  content: 'Agora vou ter bons produtos para cuidar de mim.',
  rating: 4
)

Review.create!(
  user: User.all.sample,
  carrefour_box: box2,
  content: 'Ótimos produtos.',
  rating: 4
)

Review.create!(
  user: User.all.sample,
  carrefour_box: box2,
  content: 'Entrega feita como programado, mas não gostei do esmalte',
  rating: 3
)

Review.create!(
  user: User.all.sample,
  carrefour_box: box3,
  content: 'Escolha de receitas aprovadas',
  rating: 5
)

Review.create!(
  user: User.all.sample,
  carrefour_box: box3,
  content: 'Adorei as receitas, ansiosa pela próxima surpresa',
  rating: 5
)

Review.create!(
  user: User.all.sample,
  carrefour_box: box3,
  content: 'Adorei, ingredientes todos corretos e receita ficou ótima',
  rating: 4
)

Review.create!(
  user: User.all.sample,
  carrefour_box: box3,
  content: 'Receita foi um pouco complicada de executar',
  rating: 3
)

Review.create!(
  user: User.all.sample,
  carrefour_box: box3,
  content: 'Boas receitas, superindico este BOX',
  rating: 4
)

puts ''
puts '=' * 30
puts 'Test users:'
puts 'Admin - email: admin@test.com, password: senha123'
puts 'Normal user - email: test@test.com, password: senha123'
puts '-' * 30
puts "#{User.count} users created..."
puts '-' * 30
puts "#{CarrefourBox.count} BOXes created..."
puts '-' * 30
puts "#{Plan.count} plans created..."
puts '-' * 30
puts "#{Review.count} Reviews created..."
puts '-' * 30
puts "#{Shipment.count} shipments created..."

puts ''
puts 'Seeding done!'
