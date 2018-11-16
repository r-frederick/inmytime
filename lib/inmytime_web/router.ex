defmodule InmytimeWeb.Router do
  use InmytimeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug InmytimeWeb.Plugs.ForwardedFor
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", InmytimeWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/now", PageController, :index
    get "/:timestamp", PageController, :at_time
    get "/now/in/:timezone", PageController, :convert_now
    get "/:timestamp/in/:timezone", PageController, :convert_time
    get "/now/in/:region/:subregion", PageController, :convert_now
    get "/:timestamp/in/:region/:subregion", PageController, :convert_time
  end

  # Other scopes may use custom stacks.
  # scope "/api", InmytimeWeb do
  #   pipe_through :api
  # end
end
