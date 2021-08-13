defmodule ExblogWeb.Plugs.Guards do
  import Plug.Conn
  import Phoenix.Controller, only: [put_view: 2, render: 3]

  def auth(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        case ExblogWeb.Auth.verify(token) do
          {:ok, %{"user_email" => user_email}} -> assign(conn, :user_email, user_email)
          {:error, _} -> auth_error(conn, "Invalid auth token.")
        end

      _ ->
        auth_error(conn, "Unauthorized.")
    end
  end

  defp auth_error(conn, message) do
    conn
    |> put_view(ExblogWeb.ErrorView)
    |> put_status(401)
    |> render("error.json", message: message)
    |> halt()
  end
end
