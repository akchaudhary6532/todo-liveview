defmodule AppWeb.TodoController do
  use AppWeb, :controller
  alias App.Todo

  def index(conn, _params) do
    render(conn, "groups.html", items: Todo.list_all_groups())
  end

  def task(conn, %{"id" => id}) do
    case Todo.get_task_with_group(id) do
      {:error, :not_found} ->
        response(conn, {:error, :not_found})

      result ->
        render(conn, "task.html", items: result)
    end
  end

  def task(conn, _param), do: response(conn, {:error, :bad_request})

  def mark_task_complete(conn, %{"id" => id}) do
    case Todo.update_progress(id, true) do
      {:error, reason} ->
        response(conn, {:error, reason})

      {:ok, task} ->
        conn
        |> put_status(200)
        |> redirect(to: Routes.task_todo_path(conn, :task, task.group_id))
    end
  end

  def mark_task_complete(conn, _param), do: response(conn, {:error, :bad_request})

  def mark_task_uncomplete(conn, %{"id" => id}) do
    case Todo.update_progress(id, false) do
      {:error, reason} ->
        response(conn, {:error, reason})

      {:ok, task} ->
        conn
        |> put_status(200)
        |> redirect(to: Routes.task_todo_path(conn, :task, task.group_id))
    end
  end

  # It would be better to use action_fallback controller or a helper function
  defp response(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(App.ErrorView)
    |> render(:"404")
  end

  defp response(conn, {:error, :bad_request}) do
    conn
    |> put_status(400)
    |> json(%{message: "Bad Request"})
  end

  # ChangesetView doesn't exist; writing it would be out of scope
  defp response(conn, {:error, %Ecto.Changeset{}}) do
    conn
    |> put_status(422)
    |> json(%{message: "Something went wrong?"})
  end

  defp response(conn, {:error, reason}) do
    conn
    |> put_status(422)
    |> json(%{message: reason})
  end
end
