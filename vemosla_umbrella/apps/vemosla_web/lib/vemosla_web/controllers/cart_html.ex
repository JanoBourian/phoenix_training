defmodule VemoslaWeb.CartHTML do
  use VemoslaWeb, :html

  alias Vemosla.ShoppingCart

  embed_templates "cart_html/*"

  def currency_to_str(%Decimal{} = val), do: "$#{Decimal.round(val, 2)}"
end
