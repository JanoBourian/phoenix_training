defmodule GraphicWeb.Schema.Schema do
  use Absinthe.Schema
  alias Getaways.{Accounts, Vacation}

  query do
    @desc "Get a place by its slug"
    field :place, :place do
      arg :slug, non_null(:string)
    end

  end

  #
  # Object Types
  #
  object :place do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :location, non_null(:string)
    field :slug, non_null(:string)
    field :description, non_null(:string)
    field :max_guests, non_null(:integer)
    field :pet_friendly, non_null(:boolean)
    field :pool, non_null(:boolean)
    field :wifi, non_null(:boolean)
    field :price_per_night, non_null(:decimal)
    field :image, non_null(:string)
    field :image_thumbnail, non_null(:string)
    field :bookings, list_of(:booking) do
      arg :limit, type: :integer, default_value: 100
      resolve dataloader(Vacation, :bookings, args: %{scope: :place})
    end
    field :reviews, list_of(:review), resolve: dataloader(Vacation)
  end

end
