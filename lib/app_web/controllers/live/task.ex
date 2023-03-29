defmodule AppWeb.Live.Task do
  @moduledoc false
  use AppWeb, :live_view

  alias App.Todo

  def render(assigns) do
    Phoenix.View.render(AppWeb.Live.TodoView, "task.html", assigns)
  end

  def mount(%{"group_id" => id}, _session, socket) do
    {:ok, load_update(socket, id)}
  end

  def handle_params(%{"set" => task_id}, _url, socket) do
    update_task(socket, task_id, true)
  end

  def handle_params(%{"unset" => task_id}, _url, socket) do
    update_task(socket, task_id, false)
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def load_update(socket, id) do
    assign(socket, items: Todo.get_task_with_group(id))
  end

  defp update_task(socket, task_id, action) do
    group_id = socket.assigns.items.group.id

    case Todo.update_progress(task_id, action) do
      {:ok, _} -> {:noreply, load_update(socket, group_id)}
      {:error, reason} -> {:noreply, put_flash(socket, :error, reason)}
    end
  end
end
