defmodule ExblogWeb.PostController do
  use ExblogWeb, :controller

  alias Exblog.Blog
  alias Exblog.Blog.Post
  alias Exblog.Users

  action_fallback ExblogWeb.FallbackController

  @not_found_error {:error, 404, "Not found."}
  @unauthorized_error {:error, 401, "Unauthorized."}

  def index(conn, params) do
    query_search = params["q"]
    posts = Blog.list_posts(query_search)
    render(conn, "index.json", posts: posts)
  end

  def create(conn, post_params) do
    user = Users.get_user(:email, conn.assigns.user_email)
    post_params = Map.put(post_params, "user_id", user.id)

    with {:ok, %Post{} = post} <- Blog.create_post(post_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.post_path(conn, :show, post))
      |> render("show.json", post: post)
    end
  end

  def show(conn, %{"id" => id}) do
    case Blog.get_post(id) do
      nil -> @not_found_error
      post -> render(conn, "show.json", post: post)
    end
  end

  def update(conn, %{"id" => id} = params) do
    post = Blog.get_post(id)
    user = Users.get_user(:email, conn.assigns.user_email)

    cond do
      post == nil ->
        @not_found_error

      post.user_id != user.id ->
        @unauthorized_error

      true ->
        with {:ok, %Post{} = post} <- Blog.update_post(post, params) do
          render(conn, "show.json", post: post)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Blog.get_post(id)
    user = Users.get_user(:email, conn.assigns.user_email)

    cond do
      post == nil ->
        @not_found_error

      post.user_id != user.id ->
        @unauthorized_error

      true ->
        with {:ok, %Post{}} <- Blog.delete_post(post) do
          send_resp(conn, :no_content, "")
        end
    end
  end
end
