module FakeUserGenerator
  extend ActiveSupport::Concern

  FAKE_USERS_DATA = [
    { cpf: '76547402045', street: 'Avenida Presidente Juscelino Kubitschek', number: '1444', state: 'SP',
      city: 'São Paulo' },
    { cpf: '85538880028', street: 'Rua Girassol', number: '396', state: 'SP', city: 'São Paulo' },
    { cpf: '90675768080', street: 'Rua Amauri', number: '284', state: 'SP', city: 'São Paulo' },
    { cpf: '17534292000', street: 'Avenida Rebouças', number: '955', state: 'SP', city: 'São Paulo' },
    { cpf: '37378446076', street: 'Rua Augusta', number: '3000', state: 'SP', city: 'São Paulo' },
    { cpf: '91272070050', street: 'Rua Clodomiro Amazonas', number: '482', state: 'SP', city: 'São Paulo' },
    { cpf: '34690736006', street: 'Rua Oscar Freire', number: '1128', state: 'SP', city: 'São Paulo' },
    { cpf: '05716768040', street: 'Rua Cunha Gago', number: '864', state: 'SP', city: 'São Paulo' },
    { cpf: '04656492035', street: 'Rua Harmonia', number: '77', state: 'SP', city: 'São Paulo' },
    { cpf: '81440672075', street: 'Rua Aspicuelta', number: '567', state: 'SP', city: 'São Paulo' },
    { cpf: '80739146033', street: 'Rua Conceição Veloso', number: '54', state: 'SP', city: 'São Paulo' },
    { cpf: '64075496040', street: 'Rua Araújo', number: '124', state: 'SP', city: 'São Paulo' },
    { cpf: '41234003023', street: 'Rua Antônio Lobo', number: '33', state: 'SP', city: 'São Paulo' },
    { cpf: '42102137058', street: 'Rua Doutor José Paulo', number: '103', state: 'SP', city: 'São Paulo' },
    { cpf: '46393911026', street: 'Rua Oscar Freire', number: '1052', state: 'SP', city: 'São Paulo' },
    { cpf: '84632949019', street: 'Rua Fidalga', number: '531', state: 'SP', city: 'São Paulo' },
    { cpf: '18311781095', street: 'Avenida Brigadeiro Faria Lima', number: '2902', state: 'SP', city: 'São Paulo' },
    { cpf: '30509986013', street: 'Rua Gomes de Carvalho', number: '1705', state: 'SP', city: 'São Paulo' },
    { cpf: '12474739025', street: 'Rua Flórida', number: '1488', state: 'SP', city: 'São Paulo' }
  ].freeze

  def self.generate_fake_users
    FAKE_USERS_DATA.each do |data|
      first_name = Faker::Name.unique.first_name
      last_name = Faker::Name.unique.last_name
      email = Faker::Internet.email(name: "#{first_name} #{last_name}", separators: %w[. _ -])
      user = User.create!(
        email: email,
        password: 'senha123',
        first_name: first_name,
        last_name: last_name,
        birth_date: Date.new(2001, 0o1, 0o1),
        cpf: data[:cpf],
        phone: '(11) 9876-5432',
        admin: false
      )

      address = Address.create!(
        user: user,
        name: 'casa',
        cep: '05435-040',
        street: data[:street],
        number: data[:number],
        state: data[:state],
        city: data[:city],
        main: true
      )

      boxes = CarrefourBox.all.sample(rand(1..3))
      plan = Plan.create!(
        user: user,
        quantity: boxes.size,
        address: user.addresses.first,
        carrefour_card: [true, false].sample,
        active: [true, false].sample,
        created_at: rand(30..133).days.ago
      )

      boxes.each do |box|
        box_size = Box::BOX_SIZES.sample
        items = box.box_items.sample(rand(1..4))
        items.each { |item| Box.create!(box_item: item, plan: plan, box_size: box_size) }
      end

      plan.calculate_total

      Order.create!(plan: plan, amount: plan.total_price, status: 'complete', user: user,
                    created_at: plan.created_at)

      days_till_ship = plan.ship_day - plan.created_at.day
      ship_date = plan.created_at + days_till_ship.days

      loop do
        Shipment.create!(plan: plan, created_at: ship_date, shipping_cost: plan.shipment)
        ship_date += 1.month
        break unless plan.active && ship_date < Time.now
      end

      puts "Created '#{user.first_name} #{user.last_name}' with address: #{address.full_address}"
    end
  end
end
