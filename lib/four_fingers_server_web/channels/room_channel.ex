defmodule FourFingersServerWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:" <> roomkey, %{"id" => id}, socket) do
    IO.inspect("#{id} joined #{roomkey} room!")
    
    {:ok, socket}
  end

end
