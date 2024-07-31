defmodule GraphicWeb.Resolvers.Accounts do
  alias Graphic.Accounts
  alias GraphicWeb.Schema.ChangesetErrors

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
