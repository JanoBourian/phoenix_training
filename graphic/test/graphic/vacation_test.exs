defmodule Graphic.VacationTest do
  use Graphic.DataCase

  alias Graphic.Vacation

  describe "places" do
    alias Graphic.Vacation.Place

    import Graphic.VacationFixtures

    @invalid_attrs %{}

    test "list_places/0 returns all places" do
      place = place_fixture()
      assert Vacation.list_places() == [place]
    end

    test "get_place!/1 returns the place with given id" do
      place = place_fixture()
      assert Vacation.get_place!(place.id) == place
    end

    test "create_place/1 with valid data creates a place" do
      valid_attrs = %{}

      assert {:ok, %Place{} = place} = Vacation.create_place(valid_attrs)
    end

    test "create_place/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vacation.create_place(@invalid_attrs)
    end

    test "update_place/2 with valid data updates the place" do
      place = place_fixture()
      update_attrs = %{}

      assert {:ok, %Place{} = place} = Vacation.update_place(place, update_attrs)
    end

    test "update_place/2 with invalid data returns error changeset" do
      place = place_fixture()
      assert {:error, %Ecto.Changeset{}} = Vacation.update_place(place, @invalid_attrs)
      assert place == Vacation.get_place!(place.id)
    end

    test "delete_place/1 deletes the place" do
      place = place_fixture()
      assert {:ok, %Place{}} = Vacation.delete_place(place)
      assert_raise Ecto.NoResultsError, fn -> Vacation.get_place!(place.id) end
    end

    test "change_place/1 returns a place changeset" do
      place = place_fixture()
      assert %Ecto.Changeset{} = Vacation.change_place(place)
    end
  end

  describe "bookings" do
    alias Graphic.Vacation.Booking

    import Graphic.VacationFixtures

    @invalid_attrs %{start_date: nil}

    test "list_bookings/0 returns all bookings" do
      booking = booking_fixture()
      assert Vacation.list_bookings() == [booking]
    end

    test "get_booking!/1 returns the booking with given id" do
      booking = booking_fixture()
      assert Vacation.get_booking!(booking.id) == booking
    end

    test "create_booking/1 with valid data creates a booking" do
      valid_attrs = %{start_date: ~D[2024-07-24]}

      assert {:ok, %Booking{} = booking} = Vacation.create_booking(valid_attrs)
      assert booking.start_date == ~D[2024-07-24]
    end

    test "create_booking/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vacation.create_booking(@invalid_attrs)
    end

    test "update_booking/2 with valid data updates the booking" do
      booking = booking_fixture()
      update_attrs = %{start_date: ~D[2024-07-25]}

      assert {:ok, %Booking{} = booking} = Vacation.update_booking(booking, update_attrs)
      assert booking.start_date == ~D[2024-07-25]
    end

    test "update_booking/2 with invalid data returns error changeset" do
      booking = booking_fixture()
      assert {:error, %Ecto.Changeset{}} = Vacation.update_booking(booking, @invalid_attrs)
      assert booking == Vacation.get_booking!(booking.id)
    end

    test "delete_booking/1 deletes the booking" do
      booking = booking_fixture()
      assert {:ok, %Booking{}} = Vacation.delete_booking(booking)
      assert_raise Ecto.NoResultsError, fn -> Vacation.get_booking!(booking.id) end
    end

    test "change_booking/1 returns a booking changeset" do
      booking = booking_fixture()
      assert %Ecto.Changeset{} = Vacation.change_booking(booking)
    end
  end

  describe "reviews" do
    alias Graphic.Vacation.Review

    import Graphic.VacationFixtures

    @invalid_attrs %{rating: nil}

    test "list_reviews/0 returns all reviews" do
      review = review_fixture()
      assert Vacation.list_reviews() == [review]
    end

    test "get_review!/1 returns the review with given id" do
      review = review_fixture()
      assert Vacation.get_review!(review.id) == review
    end

    test "create_review/1 with valid data creates a review" do
      valid_attrs = %{rating: 42}

      assert {:ok, %Review{} = review} = Vacation.create_review(valid_attrs)
      assert review.rating == 42
    end

    test "create_review/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vacation.create_review(@invalid_attrs)
    end

    test "update_review/2 with valid data updates the review" do
      review = review_fixture()
      update_attrs = %{rating: 43}

      assert {:ok, %Review{} = review} = Vacation.update_review(review, update_attrs)
      assert review.rating == 43
    end

    test "update_review/2 with invalid data returns error changeset" do
      review = review_fixture()
      assert {:error, %Ecto.Changeset{}} = Vacation.update_review(review, @invalid_attrs)
      assert review == Vacation.get_review!(review.id)
    end

    test "delete_review/1 deletes the review" do
      review = review_fixture()
      assert {:ok, %Review{}} = Vacation.delete_review(review)
      assert_raise Ecto.NoResultsError, fn -> Vacation.get_review!(review.id) end
    end

    test "change_review/1 returns a review changeset" do
      review = review_fixture()
      assert %Ecto.Changeset{} = Vacation.change_review(review)
    end
  end
end
