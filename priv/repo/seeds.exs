# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     App.Repo.insert!(%App.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

seeds = [
  %{
    id: 1,
    name: "Group 1",
    tasks: [
      %{id: 1, name: "Incomplete", group_id: 1},
      %{id: 2, name: "Locked task", child_task_id: 1, group_id: 1},
      %{id: 3, name: "Completed", group_id: 1, completed: true}
    ]
  },
  %{
    id: 2,
    name: "Group 2",
    tasks: [
      %{id: 4, name: "task 1", group_id: 2, completed: true},
      %{id: 5, name: "task 2", group_id: 2},
      %{id: 6, name: "task 3", group_id: 2, child_task_id: 5}
    ]
  }
]

alias App.Schema.Group
alias App.Schema.Task
alias App.Repo

Enum.each(seeds, fn group ->
  if is_nil(Repo.get(Group, group.id)) do
    Repo.insert(Group.new(%{name: group.name}))

    task = Enum.map(group.tasks, fn task -> Task.new(task) |> Repo.insert() end) |> IO.inspect()
  end
end)
