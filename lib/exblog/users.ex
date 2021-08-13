defmodule Exblog.Users do
  import Ecto.Query, warn: false
  alias Exblog.Repo

  alias Exblog.Users.User
  import Ecto.Changeset

  def list_users, do: Repo.all(User)

  def get_user(:id, id), do: Repo.get(User, id)
  def get_user(:email, email), do: Repo.get_by(User, email: email)

  def create_user(attrs \\ %{}) do
    case User.changeset(%User{}, attrs) do
      %{valid?: true} ->
        %{password_hash: password_hash} = Bcrypt.add_hash(attrs["password"])
        attrs = %{attrs | "password" => password_hash}

        %User{}
        |> User.changeset(attrs)
        |> Repo.insert()

      changeset ->
        {:error, changeset}
    end
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def login_changeset(attrs) do
    %User{}
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> apply_action(:insert)
  end
end
