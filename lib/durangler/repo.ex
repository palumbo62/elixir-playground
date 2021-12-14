defmodule Durangler.Repo do
  # See https://hexdocs.pm/ecto/Ecto.Repo.html
  # for more information on Repo usage 
  @moduledoc false
  use Ecto.Repo,
    otp_app: :durangler,
    adapter: Ecto.Adapters.Postgres
end
