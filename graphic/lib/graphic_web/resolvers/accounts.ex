defmodule GraphicWeb.Resolvers.Accounts do
  alias Graphic.Accounts
  alias GraphicWeb.Schema.ChangesetErrors

  def signin(_, %{username: username, password: password}, _) do
    case Accounts.authenticate(username, password) do
      {:error, changeset} ->
        {:error, message: "Invalid credentials"}
      {:ok, user} ->
        token = GraphicWeb.AuthToken.sign(user)
        {:ok, %{user: user, token: token}}
    end
  end

  def signup(_, args, _) do
    case Accounts.create_user(args) do
      {:error, changeset} ->
        {:error,
        message: "Could not create user!",
        details: ChangesetErrors.error_details(changeset)
        }
      {:ok, user} ->
        token = GraphicWeb.AuthToken.sign(user)
        {:ok, %{user: user, token: token}}
    end
  end
end
