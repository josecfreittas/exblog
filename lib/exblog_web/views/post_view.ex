defmodule ExblogWeb.PostView do
  use ExblogWeb, :view

  alias ExblogWeb.PostView
  alias ExblogWeb.UserView

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    base = %{
      id: post.id,
      title: post.title,
      content: post.content,
      created_at: post.inserted_at,
      updated_at: post.updated_at
    }

    case post.user do
      nil -> base
      %Ecto.Association.NotLoaded{} -> base
      _ -> Map.put(base, :user, render_one(post.user, UserView, "user.json"))
    end
  end
end
