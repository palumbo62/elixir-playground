defmodule Durangler.Repo.Migrations.CreateSalaryJobtitles do
  use Ecto.Migration

  def change do
    create table(:salary_jobtitles) do
      add :jobtitle, :string
      add :avg, :decimal
      add :name, :string
      add :symbol, :string

      timestamps()
    end

  end
end
