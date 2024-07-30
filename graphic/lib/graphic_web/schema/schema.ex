defmodule GraphicWeb.Schema.Schema do
  use Absinthe.Schema
  alias Graphic.{Accounts, Vacation}

  import_types Absinthe.Type.Custom

  query do
    @desc "Get a place by its slug"
    field :place, :place do
      arg :slug, non_null(:string)
      resolve fn _, %{slug: slug}, _ ->
        {:ok, Vacation.get_place_by_slug!(slug)}
      end
    end

    @desc "Get a list of places"
    field :places, list_of(:place) do
      arg :limit, :integer
      resolve fn _, args, _ ->
        {:ok, Vacation.list_places(args)}
      end
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
  end

end
