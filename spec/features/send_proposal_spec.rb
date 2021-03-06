require 'rails_helper'

feature 'Send Proposal' do
  scenario 'successfully' do
    #criar
    realtor = Realtor.create!(name: 'Marcos Vieira', email: 'marcos@gmail.com', password: '1234567')
    current_user = User.create!(
      name: 'Jose',
      email: 'jose.couves@mail.com',
      password: 'teste1234',
      cpf: '123345484'
    )

    region = Region.create(name: 'Copacabana')
    property_type = PropertyType.create(name: 'Apartamento')
    property = Property.create(title: 'Casa chic', room_quantity: 4 , maximum_guests: 8, minimum_rent: 2,
                        maximum_rent: 15, daily_rate: 250.0, property_type: property_type, region: region,
                        photo: File.new(Rails.root.join('spec', 'support', 'casa.jpg')), realtor: realtor)
    #navegar
    visit root_path
    click_on 'Entrar como Usuário'
    fill_in 'Email', with: 'jose.couves@mail.com' 
    fill_in 'Senha', with: 'teste1234'
    click_on 'Log in'

    select 'Copacabana', from: 'Região'
    click_on 'Buscar'
    click_on "#{property.title}"
    click_on 'Fazer proposta'

    fill_in "Data de Chegada", with: "11/11/2018"
    fill_in "Data de Saida", with: "14/11/2018"
    
    select "2", from: "Número de Hóspedes"  
    fill_in "Nome do proponente", with: "Tio chato"
    fill_in "Email", with: "tio@mail.com"
    fill_in "Telefone", with: "1144446666"
    fill_in "Finalidade da proposta", with: "Casamento"
    check "Tem pet ?"
    check "Tem Fumantes ?"
    fill_in "Mais Detalhes", with: "Casamento gay"
    click_on 'Enviar Proposta'

    #expectativa
    expect(page).to have_content('Proposta enviada com sucesso')
    expect(page).to have_content("Proposta para #{property.title}")
    expect(page).to have_content('h1', 'Feita por:')
    expect(page).to have_css('h2', text: "Tio chato")
    expect(page).to have_css('h2', text: "tio@mail.com")
    expect(page).to have_css('h3', text: 'Casamento')
    expect(page).not_to have_content('Enviar Proposta')

  end

  scenario 'unsuccessfully' do
    #criar
    realtor = Realtor.create!(name: 'Marcos Vieira', email: 'marcos@gmail.com', password: '1234567')
    region = Region.create(name: 'Copacabana')
    property_type = PropertyType.create(name: 'Apartamento')
    property = Property.create(title: 'Casa chic', room_quantity: 4 , maximum_guests: 8, minimum_rent: 2,
                               maximum_rent: 15, daily_rate: 250.0, property_type: property_type, region: region,
                               photo: File.new(Rails.root.join('spec', 'support', 'casa.jpg')), realtor: realtor)

    #navegar
    visit root_path
    select 'Copacabana', from: 'Região'
    click_on 'Buscar'
    click_on "#{property.title}"
    click_on 'Fazer proposta'

  
    fill_in "Email", with: "tio@mail.com"
    fill_in "Telefone", with: "11 44446666"
    fill_in "Finalidade da proposta", with: " "
    fill_in "Mais Detalhes", with: " "
    click_on 'Enviar Proposta'

    #expectativa
    expect(page).to have_content('Falta preencher campos')    
    expect(page).to have_button('Enviar Proposta')
  end

end