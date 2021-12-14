defmodule Durangler.Repo.Migrations.CreateCountries do
  use Ecto.Migration

  def change do
    create table(:countries) do
      add :code, :string
      add :name, :string
      add :currency_id, references(:currencies, on_delete: :nilify_all)

      timestamps()
    end

    create unique_index(:countries, [:name])
    create unique_index(:countries, [:code])
    create index(:countries, [:currency_id])  
  end
end
