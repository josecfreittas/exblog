defmodule ExblogWeb.UserView do
  use ExblogWeb, :view
  alias ExblogWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      display_name: user.display_name,
      email: user.email,
      image: user.image
    }
  end

  def render("auth.json", %{token: token}) do
    %{token: token}
  end
end
