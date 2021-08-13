defmodule Exblog.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @email_regex ~r/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/

  schema "users" do
    field :display_name, :string
    field :email, :string
    field :image, :string
    field :password, :string, redact: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:display_name, :email, :password, :image])
    |> validate_required([:display_name, :email, :password, :image])
    |> validate_length(:display_name, min: 8)
    |> validate_length(:password, min: 6)
    |> validate_format(:email, @email_regex)
    |> unique_constraint(:email, name: :users_email_index)
  end
end
