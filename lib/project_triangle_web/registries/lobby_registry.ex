defmodule ProjectTriangleWeb.LobbyRegistry do
  use Agent

  def start_link() do
    Registry.start_link(keys: :unique, name: Registry.Lobby)
    name = {:via, Registry, {Registry.Lobby, "user_ids"}}
    {:ok, _} = Agent.start_link(fn -> MapSet.new end, name: name)
  end

  ## methods ##

  def update(value) do
    Agent.update({:via, Registry, {Registry.Lobby, "user_ids"}}, fn state ->
      state
      |> MapSet.put(value)
    end)
  end

  def remove(value) do
    Agent.update({:via, Registry, {Registry.Lobby, "user_ids"}}, fn state ->
      state
      |> MapSet.delete(value)
    end)
  end

  def get() do
    Agent.get({:via, Registry, {Registry.Lobby, "user_ids"}}, fn state ->
      state
    end)
  end
end
