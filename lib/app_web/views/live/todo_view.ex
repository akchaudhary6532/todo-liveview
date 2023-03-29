defmodule AppWeb.Live.TodoView do
  use AppWeb, :view

  @incomplete "incomplete"
  @completed "completed"
  @locked "locked"

  def get_task_type(%{locked: true}), do: @locked
  def get_task_type(%{completed: false}), do: @incomplete
  def get_task_type(%{completed: true}), do: @completed

  def route(%{locked: true}), do: nil
  def route(%{completed: false}), do: :set
  def route(%{completed: true}), do: :unset
end
