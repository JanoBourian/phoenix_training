defmodule GraphicWeb.Schema.Schema do
  use Absinthe.Schema
  alias Graphic.{Accounts, Vacation}
  alias GraphicWeb.Resolvers
  alias GraphicWeb.Schema.Middleware

  import_types(Absinthe.Type.Custom)
  import Absinthe.Resolution.Helpers, only: [dataloader: 1, dataloader: 3]

  query do
    @desc "Get a place by its slug"
    field :place, :place do
      arg(:slug, non_null(:string))
      resolve(&Resolvers.Vacation.place/3)
    end

    @desc "Get a list of places"
    field :places, list_of(:place) do
      arg(:limit, :integer)
      arg(:order, type: :sort_order, default_value: :asc)
      arg(:filter, :place_filter)
      resolve(&Resolvers.Vacation.places/3)
    end

    @desc "Get the currently signed-in user"
    field :me, :user do
      resolve(&Resolvers.Accounts.me/3)
    end
  end

  mutation do
    @desc "Create a booking for a place"
    field :create_booking, :booking do
      arg(:place_id, non_null(:id))
      arg(:start_date, non_null(:date))
      arg(:end_date, non_null(:date))
      middleware(Middleware.Authenticate)
      resolve(&Resolvers.Vacation.create_booking/3)
    end

    @desc "Cancel a booking for a place"
    field :cancel_booking, :booking do
      arg(:booking_id, non_null(:id))
      middleware(Middleware.Authenticate)
      resolve(&Resolvers.Vacation.cancel_booking/3)
    end

    @desc "Create a review for a place"
    field :create_review, :review do
      arg(:place_id, non_null(:id))
      arg(:comment, non_null(:string))
      arg(:rating, non_null(:integer))
      middleware(Middleware.Authenticate)
      resolve(&Resolvers.Vacation.create_review/3)
    end

    @desc "Create a user account"
    field :signup, :session do
      arg(:username, non_null(:string))
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolvers.Accounts.signup/3)
    end

    @desc "Sign in a user"
    field :signin, :session do
      arg(:username, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolvers.Accounts.signin/3)
    end
  end

  subscription do
    @desc "Subscribe to booking changes for a place"
    field :booking_change, :booking do
      arg(:place_id, non_null(:id))

      config(fn args, _res ->
        {:ok, topic: args.place_id}
      end)
    end
  end

  #
  # Input Object Types
  #

  @desc "Filters for the list of places"
  input_object :place_filter do
    @desc "Matching a name, location, or description"
    field :matching, :string

    @desc "Has wifi"
    field :wifi, :boolean

    @desc "Allows pets"
    field :pet_friendly, :boolean

    @desc "Has a pool"
    field :pool, :boolean

    @desc "Number of guests"
    field :guest_count, :integer

    @desc "Available for booking between a start and end date"
    field :available_between, :date_range
  end

  @desc "Start and end dates"
  input_object :date_range do
    field :start_date, non_null(:date)
    field :end_date, non_null(:date)
  end

  enum :sort_order do
    value(:asc)
    value(:desc)
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
      arg(:limit, type: :integer, default_value: 100)
      resolve(dataloader(Vacation, :bookings, args: %{scope: :place}))
    end

    field :reviews, list_of(:review), resolve: dataloader(Vacation)
  end

  object :booking do
    field :id, non_null(:id)
    field :start_date, non_null(:date)
    field :end_date, non_null(:date)
    field :state, non_null(:string)
    field :total_price, non_null(:decimal)
    field :user, non_null(:user), resolve: dataloader(Accounts)
    field :place, non_null(:place), resolve: dataloader(Vacation)
  end

  object :review do
    field :id, non_null(:id)
    field :rating, non_null(:integer)
    field :comment, non_null(:string)
    field :inserted_at, non_null(:naive_datetime)
    field :user, non_null(:user), resolve: dataloader(Accounts)
    field :place, non_null(:place), resolve: dataloader(Vacation)
  end

  object :user do
    field :username, non_null(:string)
    field :email, non_null(:string)

    field :bookings, list_of(:booking),
      resolve: dataloader(Vacation, :bookings, args: %{scope: :user})

    field :reviews, list_of(:review), resolve: dataloader(Vacation)
  end

  object :session do
    field :user, non_null(:user)
    field :token, non_null(:string)
  end

  def context(ctx) do
    IO.inspect(ctx)

    loader =
      Dataloader.new()
      |> Dataloader.add_source(Vacation, Vacation.datasource())
      |> Dataloader.add_source(Accounts, Accounts.datasource())

    ctx = Map.put(ctx, :loader, loader)

    IO.inspect(ctx)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
