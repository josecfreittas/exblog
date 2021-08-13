defmodule ExblogWeb.UserController do
  use ExblogWeb, :controller

  alias Exblog.Users
  alias Exblog.Users.User
  alias ExblogWeb.Auth

  action_fallback ExblogWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, user_params) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> login(user_params)
    end
  end

  def show(conn, %{"id" => "me"}) do
    user = Users.get_user(:email, conn.assigns.user_email)
    render(conn, "show.json", user: user)
  end

  def show(conn, %{"id" => id}) do
    case Users.get_user(:id, id) do
      nil -> {:error, 404, "Not found."}
      user -> render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => "me"}) do
    user = Users.get_user(:email, conn.assigns.user_email)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def delete(_conn, %{"id" => _id}), do: {:error, 401, "Unauthorized."}

  def login(conn, params) do
    with {:ok, _} <- Users.login_changeset(params) do
      with %User{password: password_hash} <- Users.get_user(:email, params["email"]) do
        case Bcrypt.verify_pass(params["password"], password_hash) do
          true ->
            {:ok, access, _clains} = Auth.generate_access(params["email"])
            render(conn, "auth.json", token: access)

          _ ->
            {:error, 400, "Failed to log in."}
        end
      else
        _ ->
          {:error, 400, "Failed to log in."}
      end
    end
  end
end
