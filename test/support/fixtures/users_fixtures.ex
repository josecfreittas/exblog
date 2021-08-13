defmodule Exblog.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Exblog.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        "display_name" => "Brett Wiltshire",
        "email" => "brett@email.com",
        "image" => "https://i.imgur.com/uSEgddG.png",
        "password" => "123456"
      })

    Map.put(attrs, "password", fn ->
      %{password_hash: password_hash} = Bcrypt.add_hash(attrs["password"])
      password_hash
    end)

    {:ok, user} = Exblog.Users.create_user(attrs)

    user
  end
end
