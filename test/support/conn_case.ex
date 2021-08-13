defmodule ExblogWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use ExblogWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate
  import Exblog.UsersFixtures

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import ExblogWeb.ConnCase

      alias ExblogWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint ExblogWeb.Endpoint
    end
  end

  defp create_user(name) do
    user_fixture(%{"email" => "#{name}@example.com", "display_name" => name})
  end

  setup tags do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Exblog.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
    conn = Phoenix.ConnTest.build_conn()

    cond do
      Map.has_key?(tags, :signed_in) ->
        alias ExblogWeb.Auth

        user = create_user(tags[:signed_in])
        {:ok, access, _clains} = Auth.generate_access(user.email)

        conn = Plug.Conn.put_req_header(conn, "authorization", "Bearer #{access}")
        {:ok, conn: conn, current_user: user}

      Map.has_key?(tags, :invalid_auth_token) ->
        conn = Plug.Conn.put_req_header(conn, "authorization", "Bearer invalid.token")
        {:ok, conn: conn, current_user: nil}

      true ->
        {:ok, conn: conn, current_user: nil}
    end
  end
end
