defmodule GraphicWeb.Resolvers.Vacation do
  alias Graphic.Vacation
  alias GraphicWeb.Schema.ChangesetErrors

  def place(_, %{slug: slug}, _) do
    {:ok, Vacation.get_place_by_slug!(slug)}
  end

  def places(_, args, _) do
    {:ok, Vacation.list_places(args)}
  end

  def create_booking(_, args, %{context: %{current_user: user}}) do
    case Vacation.create_booking(user, args) do
      {:error, changeset} ->
        {:error,
        message: "Could not create booking!",
        details: ChangesetErrors.error_details(changeset)
        }
      {:ok, booking} ->
        {:ok, booking}
    end
  end
end
