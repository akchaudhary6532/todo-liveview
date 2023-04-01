defmodule App.Schema.Group do
  @moduledoc """
  Schema file for Groups
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias App.Schema.Task

  @type t :: %{required(:name) => String.t()}

  schema "group" do
    field :name, :string
    has_many :tasks, Task
  end

  @fields ~w(name)a

  @spec new(t) :: Ecto.Changeset.t()
  def new(attrs), do: changeset(%__MODULE__{}, attrs)

  @spec changeset(Ecto.Schema.t() | t(), t()) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
