# TODO app using liveview and rest.

# Endpoints
  * to view the liveview code, visit [`http://localhost:4000/live`](http://localhost:4000/live)
  * to view the REST API code, visit [`http://localhost:4000/rest`](http://localhost:4000/rest)

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`



# Assumptions.
  * Data is seeded. or already exist in the DB. There is not API to create group/task. We can only view or take action on the tasks.
  * Once a parent task is completed. dependant task cannot be marked as incomplete.
  * OpenAPIspec does not apply since these are not Json APIs, hence @spec exists only for model and context.
