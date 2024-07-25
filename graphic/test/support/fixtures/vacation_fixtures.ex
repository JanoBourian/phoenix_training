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

  @doc """
  Generate a booking.
  """
  def booking_fixture(attrs \\ %{}) do
    {:ok, booking} =
      attrs
      |> Enum.into(%{
        start_date: ~D[2024-07-24]
      })
      |> Graphic.Vacation.create_booking()

    booking
  end
end
