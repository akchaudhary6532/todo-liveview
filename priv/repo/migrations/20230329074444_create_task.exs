defmodule App.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def change do
    create table(:task) do
      add :name, :string
      add :completed, :boolean
      add :child_task_id, references(:task)
      add :group_id, references(:group)
    end
  end
end
