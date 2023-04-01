defmodule AppWeb.TodoController do
  use AppWeb, :controller
  alias App.Todo

  action_fallback(AppWeb.FallbackController)

  def index(conn, _params) do
    render(conn, "groups.html", items: Todo.list_all_groups())
  end

  def task(conn, %{"id" => id}) do
    case Todo.get_task_with_group(id) do
      {:error, :not_found} ->
        {:error, :not_found}

      result ->
        render(conn, "task.html", items: result)
    end
  end

  def task(_conn, _param), do: {:error, :bad_request}

  def mark_task_complete(conn, %{"id" => id}) do
    case Todo.update_progress(id, true) do
      {:error, reason} ->
        {:error, reason}

      {:ok, task} ->
        conn
        |> put_status(302)
        |> redirect(to: Routes.task_todo_path(conn, :task, task.group_id))
    end
  end

  def mark_task_complete(_conn, _param), do: {:error, :bad_request}

  def mark_task_uncomplete(conn, %{"id" => id}) do
    case Todo.update_progress(id, false) do
      {:error, reason} ->
        {:error, reason}

      {:ok, task} ->
        conn
        |> put_status(302)
        |> redirect(to: Routes.task_todo_path(conn, :task, task.group_id))
    end
  end
end
