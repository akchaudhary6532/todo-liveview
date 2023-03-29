defmodule App.Repo.Migrations.CreateGroup do
  use Ecto.Migration

  def change do
    create table(:group) do
      add :name, :string
    end
  end
end
