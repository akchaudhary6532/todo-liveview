ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(App.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:ex_machina)
