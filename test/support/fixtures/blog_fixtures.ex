defmodule Exblog.BlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Exblog.Blog` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        content: "some content",
        title: "some title"
      })
      |> Exblog.Blog.create_post()

    post
  end
end
