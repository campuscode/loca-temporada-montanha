class PropertiesController < ApplicationController
  before_action :set_property, only: [:show]

  def show; end

  def new
    @property = Property.new
    @regions = Region.all
    @property_types = PropertyType.all
  end

  def index
    @properties = Property.all
  end

  def edit
    @property_types = PropertyType.all
    @regions = Region.all
    id = params[:id]
    @property = Property.find(id)
  end

  def update
    @property_types = PropertyType.all
    @regions = Region.all
    id = params[:id]
    @property = Property.find(id)


    if @property.update(property_params)
      flash[:notice] = 'Imóvel atualizado com sucesso'
      redirect_to property_path
    else
      flash[:alert] = 'Campos em branco'
      render 'edit'
    end
  end

  def create
    @property = Property.new(property_params)
    @property.realtor = current_realtor
    if @property.save
      flash[:success] = 'Imóvel cadastrado com sucesso'
      redirect_to @property
    else
      flash[:alert] = 'Você deve preencher todos os campos'
      @regions = Region.all
      @property_types = PropertyType.all
      render :new
    end
  end

  private

  def set_property
    @property = Property.find(params[:id])
  end

  def property_params
    params.require(:property).permit(:title, :description, :property_type_id,
                                     :region_id, :rent_purpose, :area,
                                     :room_quantity, :accessibility,
                                     :allow_pets, :allow_smokers,
                                     :maximum_guests, :minimum_rent,
                                     :maximum_rent, :daily_rate, 
                                     :photo)
  end
end

