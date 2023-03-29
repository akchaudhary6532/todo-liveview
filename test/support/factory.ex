defmodule App.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: App.Repo

  alias App.Schema.Group
  alias App.Schema.Task

  def group_factory do
    %Group{
      name: Faker.Person.first_name()
    }
  end

  def task_factory(map) do
    %Task{
      name: Faker.Company.name(),
      completed: Map.get(map, :completed, false),
      child_task_id: Map.get(map, :child_task_id),
      group_id: map.group_id
    }
  end
end
