defmodule FourFingersServerWeb.RoomSub do
  use GenServer
  use Agent

  def start_link() do
    GenServer.start_link(__MODULE__, %{})
    Agent.start_link(fn -> MapSet.new end, name: __MODULE__)
  end

  def init(topics) do
    Registry.register(FourFingersServerWeb.RoomPub, "foo", [])
    {:ok, topics}
  end

  def handle_cast({:broadcast, "save", data}, topics) do
    Agent.update(__MODULE__, &MapSet.put(&1, data))
    Agent.get(__MODULE__, fn state ->
      IO.puts("\n*** state")
      IO.inspect(state)
      IO.puts("\n")
      state
    end)
    {:noreply, topics}
  end
end
