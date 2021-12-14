defmodule DuranglerWeb.Router do
   @moduledoc """
    A module providing scope, pipeline, and route definitions for each
    application controller.

    Refer to (https://hexdocs.pm/phoenix/Phoenix.Router.html) for detailed
    examples on routing configuration.

    Run the following command from the main application directory to
    obtain a listing of all supported routes

      `$ mix phx.routes`
  """
  use DuranglerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DuranglerWeb do
    pipe_through :api
    resources "/currencies", CurrencyController, except: [:new, :edit] 
    resources "/countries", CountryController, except: [:new, :edit] 
    resources "/employees", EmployeeController, except: [:new, :edit]
  end
  
  pipeline :admin do
    plug :accepts, ["json"]
  end

  scope "/metrics", DuranglerWeb do
    pipe_through :admin
    resources "/salary_countries", SalaryCountryController, only: [:index, :show]
    resources "/salary_jobtitles", SalaryJobtitleController, only: [:index, :show]
  end    

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: DuranglerWeb.Telemetry, ecto_repos: [Durangler.Repo]
    end
  end
end
