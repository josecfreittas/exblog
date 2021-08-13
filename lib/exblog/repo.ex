defmodule Exblog.Repo do
  use Ecto.Repo,
    otp_app: :exblog,
    adapter: Ecto.Adapters.Postgres
end
