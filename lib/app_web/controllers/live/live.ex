defmodule AppWeb.Live.Todo do
  @moduledoc false
  use AppWeb, :live_view

  alias App.Todo

  @type socket :: Phoenix.LiveView.Socket.t()
  @type assigns :: Phoenix.LiveView.Socket.assigns()
  @type rendered :: Elixir.Phoenix.LiveView.Rendered.t()

  @spec render(assigns) :: rendered
  def render(assigns) do
    Phoenix.View.render(AppWeb.Live.TodoView, "groups.html", assigns)
  end

  @spec mount(map(), map(), socket()) :: {:ok, socket()}
  def mount(_params, _session, socket) do
    {:ok, assign(socket, items: Todo.list_all_groups())}
  end

  @spec handle_params(map(), String.t(), socket()) :: {:noreply, socket()}
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end
end
