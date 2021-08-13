defmodule ExblogWeb.Router do
  use ExblogWeb, :router
  import ExblogWeb.Plugs.Guards

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExblogWeb do
    pipe_through :api

    post "/users", UserController, :create
    post "/users/login", UserController, :login

    pipe_through [:auth]

    get "/users", UserController, :index
    get "/users/:id", UserController, :show
    delete "/users/:id", UserController, :delete
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
