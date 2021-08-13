defmodule ExblogWeb.PostView do
  use ExblogWeb, :view
  alias ExblogWeb.PostView

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{
      id: post.id,
      title: post.title,
      content: post.content,
      user_id: post.user_id,
      created_at: post.inserted_at,
      updated_at: post.updated_at,
    }
  end
end
