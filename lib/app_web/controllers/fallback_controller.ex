defmodule AppWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.
  """
  use AppWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(AppWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :bad_request}) do
    conn
    |> put_status(400)
    |> json(%{message: "Bad Request"})
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_view(AppWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, reason}) do
    conn
    |> put_status(422)
    |> json(%{message: reason})
  end
end
