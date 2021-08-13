defmodule ExblogWeb.Router do
  use ExblogWeb, :router
  import ExblogWeb.Plugs.Guards

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/users", ExblogWeb do
    pipe_through :api

    post "/", UserController, :create
    post "/login", UserController, :login

    pipe_through [:auth]

    get "/", UserController, :index
    get "/:id", UserController, :show
    delete "/:id", UserController, :delete
  end

  scope "/posts", ExblogWeb do
    pipe_through [:api, :auth]

    get "/", PostController, :index
    post "/", PostController, :create
    get "/:id", PostController, :show
    put "/:id", PostController, :update
    delete "/:id", PostController, :delete
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
