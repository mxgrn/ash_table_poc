defmodule AshTableWeb.Router do
  use AshTableWeb, :router
  import AshAdmin.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AshTableWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser

    ash_admin("/admin")
  end

  scope "/", AshTableWeb do
    pipe_through :browser

    live "/", Ash.UsersLive, :index

    # Traditional live views
    live "/users", UserLive.Index, :index
    live "/users/new", UserLive.Index, :new
    live "/users/:id", UserLive.Show, :show
    live "/users/:id/show/edit", UserLive.Show, :edit
  end

  scope "/ash", AshTableWeb.Ash do
    pipe_through :browser

    live "/books", BooksLive, :index
    live "/books/new", BooksLive, :new
    live "/books/:id/edit", BooksLive, :edit

    live "/users", UsersLive, :index
    live "/users/new", UsersLive, :new
    live "/users/:id", UsersLive, :show
    live "/users/:id/edit", UsersLive, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", AshTableWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ash_table, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AshTableWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
