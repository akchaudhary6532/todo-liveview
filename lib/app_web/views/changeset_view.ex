defmodule AppWeb.ChangesetView do
  use AppWeb, :view

  @moduledoc """
  translates changeset errors to json
  """

  def render("error.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{message: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)}
  end
end
