defmodule Exblog.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  alias Exblog.Repo

  alias Exblog.Blog.Post

  def list_posts(nil), do: Repo.all(Post)

  def list_posts(query_search) do
    ilike = "%#{query_search}%"

    query =
      from p in Post,
        where: ilike(p.title, ^ilike) or ilike(p.content, ^ilike)

    Repo.all(query)
  end

  def get_post(id), do: Repo.get(Post, id)

  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def update_post(%Post{} = post, attrs) do
    case Post.changeset(%Post{}, attrs) do
      %{valid?: true} ->
        post
        |> Post.changeset(attrs)
        |> Repo.update()

      changeset ->
        {:error, changeset}
    end
  end

  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end
end
