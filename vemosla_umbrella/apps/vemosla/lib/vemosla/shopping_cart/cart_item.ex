defmodule Vemosla.ShoppingCart.CartItem do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "cart_items" do
    field :price_when_carted, :decimal
    field :quantity, :integer
    field :cart_id, :binary_id
    field :product_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(cart_item, attrs) do
    cart_item
    |> cast(attrs, [:price_when_carted, :quantity])
    |> validate_required([:price_when_carted, :quantity])
  end
end
