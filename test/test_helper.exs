defmodule MyGenServer do
  def start_link(), do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)

  def run(), do: GenServer.call(__MODULE__, :run)

  def init(_), do: {:ok, "Done !!!"}

  def handle_call(:run, _from, state), do: {:reply, state, state}
end

MyGenServer.start_link()

ExUnit.start()
