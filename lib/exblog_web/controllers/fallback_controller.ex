defmodule ExblogWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use ExblogWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ExblogWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ExblogWeb.ErrorView)
    |> render(:"404")
  end

  # This clause handles generic erros comming from above.
  def call(conn, {:error, code, message}) do
    conn
    |> put_view(ExblogWeb.ErrorView)
    |> put_status(code)
    |> render("error.json", message: message)
  end
end
