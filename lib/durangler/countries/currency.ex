defmodule Durangler.Countries.Currency do
  @moduledoc """
    Defines the schema and changeset used to map 
    currency data between the application and the
    database, as well as, to validate the data
    against the specified changeset pipeline. 
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "currencies" do
    field :code, :string
    field :name, :string
    field :symbol, :string

    timestamps()
  end

  @doc false
  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:code, :name, :symbol])
    |> validate_required([:code, :name, :symbol])
    |> validate_length(:code, is: 3)
    |> validate_length(:name, min: 1, max: 50)
    |> validate_length(:symbol, min: 1, max: 3)
    |> unique_constraint(:code)
  end
end
