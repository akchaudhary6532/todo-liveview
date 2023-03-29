defmodule App.Todo do
  @moduledoc """
  Context File for Todo App.
  """
  import Ecto.Query
  use Ecto.Schema

  alias App.Schema.Group
  alias App.Repo
  alias App.Schema.Task

  @type task :: %{
          group: Group.t(),
          tasks:
            list(%{
              id: non_neg_integer(),
              name: String.t(),
              completed: String.t(),
              locked: boolean() | nil
            })
        }

  @type group :: %{
          total: non_neg_integer(),
          completed: non_neg_integer(),
          name: String.t(),
          id: non_neg_integer()
        }

  @spec list_all_groups :: group()
  def list_all_groups do
    Group
    |> join(:left, [g], t in Task, on: t.group_id == g.id)
    |> group_by([g, t], g.id)
    |> select([g, t], %{
      total: count(t.id),
      completed: fragment("SUM(CASE WHEN ? = true THEN 1 ELSE 0 END)", t.completed),
      name: g.name,
      id: g.id
    })
    |> order_by([g, t], g.id)
    |> Repo.all()
  end

  @spec list_all_task_for_group(integer()) :: list(task()) | []
  def list_all_task_for_group(group_id) do
    Task
    |> join(:left, [t], t2 in assoc(t, :child_task))
    |> where([t], t.group_id == ^group_id)
    |> select([task, child], %{
      name: task.name,
      completed: task.completed,
      locked: not child.completed,
      id: task.id
    })
    |> order_by([t], t.id)
    |> Repo.all()
  end

  @spec get_task_with_group(integer()) ::
          {:error, :not_found} | %{group: Group.t(), tasks: list(task())}
  def get_task_with_group(group_id) do
    case Repo.get(Group, group_id) do
      nil -> {:error, :not_found}
      group -> %{group: group, tasks: list_all_task_for_group(group_id)}
    end
  end

  @spec update_progress(integer(), boolean()) ::
          {:ok, Task.t()}
          | {:error, Ecto.Changeset.t() | :not_found | :pending_child | :parent_completed}
  def update_progress(task_id, true) do
    with %Task{} = task <- Repo.get(Task, task_id),
         {:child, true} <- {:child, is_child_completed?(task)} do
      task
      |> Task.changeset(%{completed: true})
      |> Repo.update()
    else
      nil -> {:error, :not_found}
      {:child, false} -> {:error, :pending_child}
    end
  end

  def update_progress(task_id, false) do
    with %Task{} = task <- Repo.get(Task, task_id),
         {:child, true} <- {:child, is_child_completed?(task)},
         {:parent, false} <- {:parent, is_parent_complete?(task)} do
      task
      |> Task.changeset(%{completed: false})
      |> Repo.update()
    else
      nil -> {:error, :not_found}
      {:child, false} -> {:error, :pending_child}
      {:parent, true} -> {:error, :parent_completed}
    end
  end

  defp is_parent_complete?(task) do
    case Repo.get_by(Task, child_task_id: task.id) do
      nil -> false
      parent -> parent.completed
    end
  end

  defp is_child_completed?(%Task{child_task_id: nil}), do: true

  defp is_child_completed?(%Task{child_task_id: task_id}) do
    ## Let it break if data is inconsistent and task doesn't exist
    task = Repo.get(Task, task_id)
    task.completed
  end
end
