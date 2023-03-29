defmodule App.TodoTest do
  use App.DataCase

  alias App.Factory
  alias App.Todo

  describe "list_all_groups/0" do
    test "when no groups" do
      assert Todo.list_all_groups() == []
    end

    test "when group exist without task" do
      # given
      group = Factory.insert(:group)
      # when
      # then
      assert Todo.list_all_groups() == [%{id: group.id, name: group.name, completed: 0, total: 0}]
    end

    test "when group exist with incomplete task" do
      # given
      group = Factory.insert(:group)
      _task = Factory.insert(:task, %{group_id: group.id})
      # when
      # then
      assert Todo.list_all_groups() == [%{id: group.id, name: group.name, completed: 0, total: 1}]
    end

    test "when group exist with complete task" do
      # given
      group = Factory.insert(:group)
      _task = Factory.insert(:task, %{group_id: group.id, completed: true})
      # when
      # then
      assert Todo.list_all_groups() == [%{id: group.id, name: group.name, completed: 1, total: 1}]
    end
  end

  describe "list_all_task_for_group/1" do
    test "when no group" do
      assert Todo.list_all_task_for_group(1) == []
    end

    test "when group exist with incomplete locked task " do
      # given
      group = Factory.insert(:group)
      # when

      task = Factory.insert(:task, %{group_id: group.id})
      task2 = Factory.insert(:task, %{group_id: group.id, child_task_id: task.id})
      # then
      assert Todo.list_all_task_for_group(group.id) == [
               %{completed: false, id: task.id, locked: nil, name: task.name},
               %{completed: false, id: task2.id, locked: true, name: task2.name}
             ]
    end
  end

  describe "update_progress/2" do
    test "when update/set pending task" do
      # given
      group = Factory.insert(:group)
      # when

      task = Factory.insert(:task, %{group_id: group.id})
      task2 = Factory.insert(:task, %{group_id: group.id, child_task_id: task.id})
      # then
      assert Todo.update_progress(task.id, true) == {:ok, Map.put(task, :completed, true)}
    end

    test "when update/set locked task" do
      # given
      group = Factory.insert(:group)
      # when

      task = Factory.insert(:task, %{group_id: group.id})
      task2 = Factory.insert(:task, %{group_id: group.id, child_task_id: task.id})
      # then
      assert Todo.update_progress(task2.id, true) == {:error, :pending_child}
    end

    test "when update/unset completed task which is linked to other completed task" do
      # given
      group = Factory.insert(:group)
      # when

      task = Factory.insert(:task, %{group_id: group.id, completed: true})

      task2 =
        Factory.insert(:task, %{group_id: group.id, child_task_id: task.id, completed: true})

      # then
      assert Todo.update_progress(task.id, false) == {:error, :parent_completed}
    end

    test "when update/unset completed task" do
      # given
      group = Factory.insert(:group)
      # when

      task = Factory.insert(:task, %{group_id: group.id, completed: true})
      # then
      assert Todo.update_progress(task.id, false) == {:ok, Map.put(task, :completed, false)}
    end
  end
end
