defmodule GraphicWeb.Resolvers.Vacation do
  alias Graphic.Vacation

  def place(_, %{slug: slug}, _ ) do
    {:ok, Vacation.get_place_by_slug!(slug)}
  end

  def places(_, args, _) do
    {:ok, Vacation.list_places(args)}
  end

  def bookings_for_place(place, _, _) do
    {:ok, Vacation.bookings_for_place(place)}
  end
end