defmodule AppWeb.Live.Todo do
  @moduledoc false
  use AppWeb, :live_view

  alias App.Todo

  def render(assigns) do
    Phoenix.View.render(AppWeb.Live.TodoView, "groups.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, items: Todo.list_all_groups())}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end
end
