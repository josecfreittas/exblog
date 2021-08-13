defmodule Exblog.BlogFixtures do
  import Exblog.UsersFixtures

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Exblog.Blog` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    user = user_fixture(%{"email" => "myfixture@email.com"})

    {:ok, post} =
      attrs
      |> Enum.into(%{
        content: "some content",
        title: "some title",
        user: user
      })
      |> Exblog.Blog.create_post()

    post
  end
end
