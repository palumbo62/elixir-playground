defmodule Durangler.Metrics.SalaryJobtitle do
  @moduledoc """
    Defines changeset used to validate the salary
    data against the specified changeset pipeline. 
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "salary_jobtitles" do
    field :avg, :decimal
    field :jobtitle, :string
    field :name, :string
    field :symbol, :string

    timestamps()
  end

  @doc false
  def changeset(salary_jobtitle, attrs) do
    salary_jobtitle
    |> cast(attrs, [:jobtitle, :avg, :name, :symbol])
    |> validate_required([:jobtitle, :avg, :name, :symbol])
  end
end
