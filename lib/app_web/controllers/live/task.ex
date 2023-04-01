defmodule AppWeb.Live.Task do
  @moduledoc false
  use AppWeb, :live_view

  alias App.Todo

  @type socket :: Phoenix.LiveView.Socket.t()
  @type assigns :: Phoenix.LiveView.Socket.assigns()
  @type rendered :: Elixir.Phoenix.LiveView.Rendered.t()

  @spec render(assigns) :: rendered
  def render(assigns) do
    Phoenix.View.render(AppWeb.Live.TodoView, "task.html", assigns)
  end

  @spec mount(map(), map(), socket()) :: {:ok, socket()}
  def mount(%{"group_id" => id}, _session, socket) do
    {:ok, load_update(socket, id)}
  end

  @spec handle_params(map(), String.t(), socket()) :: {:noreply, socket()}
  def handle_params(params, _url, socket) do
    case params do
      %{"set" => task_id} ->
        update_task(socket, task_id, true)

      %{"unset" => task_id} ->
        update_task(socket, task_id, false)

      %{"locked" => _task_id} ->
        {:noreply, put_flash(socket, :error, parse_update_progress_errors(:pending_child))}

      _ ->
        {:noreply, socket}
    end
  end

  @spec load_update(socket(), non_neg_integer()) :: socket()
  defp load_update(socket, id) do
    case Todo.get_task_with_group(id) do
      {:error, :not_found} -> put_flash(socket, :error, "Group not found.")
      items -> assign(socket, items: items)
    end
  end

  @spec update_task(socket, non_neg_integer(), boolean()) :: {:noreply, socket()}
  defp update_task(socket, task_id, action) do
    group_id = socket.assigns.items.group.id

    case Todo.update_progress(task_id, action) do
      {:ok, _} ->
        {:noreply, load_update(socket, group_id)}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, parse_update_progress_errors(reason))}
    end
  end

  defp parse_update_progress_errors(:not_found), do: "Task id not found"

  defp parse_update_progress_errors(:pending_child),
    do: "Task locked. Please complete other task first."

  defp parse_update_progress_errors(:parent_completed),
    do: "Task dependant on it has already been completed."
end
