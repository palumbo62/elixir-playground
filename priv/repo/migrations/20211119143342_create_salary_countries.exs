defmodule Durangler.Repo.Migrations.CreateSalaryCountries do
  use Ecto.Migration

  def change do
    create table(:salary_countries) do
      add :min, :decimal
      add :max, :decimal
      add :avg, :decimal
      add :code, :string
      add :crcode, :string

      timestamps()
    end

  end
end
