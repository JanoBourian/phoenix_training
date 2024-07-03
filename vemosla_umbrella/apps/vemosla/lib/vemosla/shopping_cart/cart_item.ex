defmodule Vemosla.ShoppingCart.CartItem do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "cart_items" do
    field :price_when_carted, :decimal
    field :quantity, :integer
    belongs_to :cart, Vemosla.ShoppingCart.Cart
    belongs_to :product, Vemosla.Catalog.Product

    timestamps()
  end

  @doc false
  def changeset(cart_item, attrs) do
    cart_item
    |> cast(attrs, [:price_when_carted, :quantity])
    |> validate_required([:price_when_carted, :quantity])
    |> validate_number(:quantity, greater_than_or_equal_to: 0, less_than: 100)
  end
end
