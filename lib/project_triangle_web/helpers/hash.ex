defmodule ProjectTriangleWeb.Helpers.Hash do
  def gen_random_str() do
    text = :os.timestamp |> Tuple.to_list |> Enum.join("/")
    text = text <> ProjectTriangleWeb.Endpoint.config(:salt)
    :crypto.hash(:sha384, text) |> Base.encode64
  end
end
  