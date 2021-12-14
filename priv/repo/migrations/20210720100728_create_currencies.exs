defmodule Durangler.Repo.Migrations.CreateCurrencies do
  use Ecto.Migration

  def change do
    create table(:currencies) do
      add :code, :string
      add :name, :string
      add :symbol, :string

      timestamps()
    end

    create unique_index(:currencies, [:code])
  end
end
