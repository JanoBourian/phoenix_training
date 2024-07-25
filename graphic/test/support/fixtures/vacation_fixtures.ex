defmodule Graphic.VacationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Graphic.Vacation` context.
  """

  @doc """
  Generate a place.
  """
  def place_fixture(attrs \\ %{}) do
    {:ok, place} =
      attrs
      |> Enum.into(%{

      })
      |> Graphic.Vacation.create_place()

    place
  end
end
