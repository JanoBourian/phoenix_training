defmodule VemoslaWeb.Router do
  use VemoslaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {VemoslaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug VemoslaWeb.Plugs.Locale, "en"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VemoslaWeb do
    pipe_through :browser
    get "/", PageController, :home
    get "/about", PageController, :index
    get "/hello/:messenger", PageController, :show
    get "/janobourian/:id", PageController, :janobourian
    resources "/users", UserController
    resources "/posts", PostController, only: [:index, :show]
    resources "/comments", CommentController, except: [:delete]
    resources "/reviews", ReviewController
    resources "/users", UserController do
      resources "/posts", PostController
    end
  end

  scope "/admin", VemoslaWeb.Admin do
    pipe_through :browser

    resources "/reviews", ReviewController
  end

  scope "/api", VemoslaWeb.Api, as: :api do
    pipe_through :browser
    scope "/v1", V1, as: :v1 do
      resources "/images", ImageController
      resources "/reviews", ReviewController
      resources "/users", UserController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", VemoslaWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:vemosla_web, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: VemoslaWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
