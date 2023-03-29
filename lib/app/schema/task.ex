defmodule App.Schema.Task do
  @moduledoc """
  Schema file for tasks
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias App.Schema.Group

  @type t :: %__MODULE__{
          name: String.t(),
          completed: boolean(),
          child_task_id: non_neg_integer() | nil,
          group_id: non_neg_integer()
        }

  @type params :: %{
          optional(:name) => String.t(),
          optional(:completed) => boolean(),
          optional(:child_task_id) => integer(),
          optional(:group_id) => integer()
        }

  schema "task" do
    field :name, :string
    field :completed, :boolean, default: false
    belongs_to :child_task, __MODULE__
    belongs_to :group, Group
  end

  @required ~w(name group_id)a

  @fields @required ++ ~w(completed child_task_id)a

  @spec new(params) :: Ecto.Changeset.t()
  def new(attrs), do: changeset(%__MODULE__{}, attrs)

  @spec changeset(Ecto.Schema.t() | t(), params()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @fields)
    |> validate_required(@required)
    |> foreign_key_constraint(:group_id)
    |> foreign_key_constraint(:child_taks_id)
    |> ensure_child_is_not_self()
  end

  defp ensure_child_is_not_self(
         %Ecto.Changeset{valid?: true, data: %{id: id}, changes: %{child_task_id: id}} = changeset
       )
       when not is_nil(id) do
    add_error(changeset, :child_task_id, "Child cannot be self!")
  end

  defp ensure_child_is_not_self(changeset), do: changeset
end
