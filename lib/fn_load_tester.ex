defmodule FnLoadTester do
  @moduledoc """
  FnLoadTester is a Load Tester for your functions.
  """

  @doc """
  Main function of the module.

  * clients: number of parallel clients
  * requests: number of requests per client
  * func: function to be evaluated
  * stats: (optional) list of Stats which implement the behaviour `FnLoadTester.Stats`. 
    If no list is specified, the default one will be executed.

  ## Examples

      iex> FnLoadTester.request(1, 100, fn -> MyGenServer.execute() end)
      Maximum:                104610  ns
      Minimum:                20123   ns
      Average:                26940   ns
      Percentile50:           21877   ns
      Percentile90:           36460   ns
      Percentile95:           50784   ns
      Percentile99:           104610  ns
      :ok
  """
  @spec request(integer(), integer(), fun(), [module()]) :: :ok
  def request(clients, requests, func, stats \\ FnLoadTester.Stats.get_default_stats()) do
    1..clients
    |> Enum.map(fn _ -> Task.async(fn -> run(func, requests) end) end)
    |> Enum.map(fn task -> Task.await(task) end)
    |> List.flatten()
    |> calculations(stats)
  end

  defp run(_request, requests) when requests < 0, do: []
  defp run(func, requests), do: do_run(func, requests, [])
  defp do_run(_request, 0, results), do: results

  defp do_run(func, requests, results) do
    tic = :os.system_time(:nanosecond)
    func.()
    latency = :os.system_time(:nanosecond) - tic
    do_run(func, requests - 1, [latency | results])
  end

  defp calculations(results, stats) do
    stats
    |> Enum.map(fn mod -> Task.async(fn -> apply(mod, :run, [results]) end) end)
    |> Enum.each(fn task -> IO.puts(Task.await(task)) end)
  end
end
