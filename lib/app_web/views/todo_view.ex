defmodule AppWeb.TodoView do
  use AppWeb, :view

  @incomplete "incomplete"
  @completed "completed"
  @locked "locked"

  def get_task_type(%{locked: true}), do: @locked

  def get_task_type(%{completed: false}), do: @incomplete

  def get_task_type(%{completed: true}), do: @completed

  def disabled(%{locked: true}), do: [{"disabled", true}]
  def disabled(_), do: []

  def route(task) do
    case get_task_type(task) do
      @incomplete -> :mark_task_complete
      @completed -> :mark_task_uncomplete
    end
  end
end
