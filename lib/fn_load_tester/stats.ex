defmodule FnLoadTester.Stats do
  @moduledoc """
  Behaviour to build Statistics of the Load Test.

  To Build a new `Stats` it is only necessary to `use FnLoadTester.Stats` and implement the callbacks:
    * calculate(list): the input is a list of times and the output has to be a number
    * units(): The outpus has to be an atom which indicates the unit of the output of calculate:
      * :nanosecond
      * :microsecond
      * :millisecond
      * :second
    * title(): The output will be a string with the Title of the Stats.

    ```elixir
      defmodule MyMaximum do
          use FnLoadTester.Stats

          def calculate(data), do: Enum.max(data)
          def units(), do: :nanosecond
          def title(), do: "Maximum"
      end
    ```
  """

  @default_stats [
    FnLoadTester.Stats.Maximum,
    FnLoadTester.Stats.Minimum,
    FnLoadTester.Stats.Average,
    FnLoadTester.Stats.Percentile50,
    FnLoadTester.Stats.Percentile90,
    FnLoadTester.Stats.Percentile95,
    FnLoadTester.Stats.Percentile99
  ]

  @callback calculate([number()]) :: number()
  @callback units() :: atom()
  @callback title() :: binary()

  @doc """
  It returns the default Stats.
  """
  def get_default_stats(), do: @default_stats

  defmacro __using__(_) do
    quote do
      @behaviour Stats
      def run(data) do
        result = calculate(data)
        "#{title()}:\t\t#{result}\t#{string_units()}"
      end

      def string_units() do
        case units() do
          :nanosecond -> "ns"
          :microsecond -> "us"
          :millisecond -> "ns"
          :second -> "s"
          _ -> "unknown"
        end
      end
    end
  end
end

defmodule FnLoadTester.Stats.Maximum do
  @moduledoc """
  Default Maximum.
  """
  use FnLoadTester.Stats

  def calculate(data), do: Enum.max(data)
  def units(), do: :nanosecond
  def title(), do: "Maximum"
end

defmodule FnLoadTester.Stats.Minimum do
  @moduledoc """
  Default Minimum.
  """
  use FnLoadTester.Stats

  def calculate(data), do: Enum.min(data)
  def units(), do: :nanosecond
  def title(), do: "Minimum"
end

defmodule FnLoadTester.Stats.Average do
  @moduledoc """
  Default Average.
  """
  use FnLoadTester.Stats

  def calculate(data), do: average(data)
  def units(), do: :nanosecond
  def title(), do: "Average"

  defp average(results) do
    {n, d} = Enum.reduce(results, {0, 0}, fn x, {n, d} -> {n + x, d + 1} end)
    Kernel.trunc(n / d)
  end
end

defmodule FnLoadTester.Stats.Percentile do
  @moduledoc """
  Helper module to calculate Percentiles.
  """

  @doc """
  It return the percentile **p** of the given **data**
  """
  @spec percentile([number()], integer()) :: number()
  def percentile(data, p) do
    sorted_data = Enum.sort(data)
    count = Enum.count(sorted_data)
    position = max(0.0, Kernel.trunc(count * p / 100))
    get_array_position(sorted_data, position)
  end

  defp get_array_position([], _), do: nil

  defp get_array_position([h | _], 0), do: h

  defp get_array_position([_ | t], position), do: get_array_position(t, position - 1)
end

defmodule FnLoadTester.Stats.Percentile50 do
  @moduledoc """
  Default Percentile 50.
  """
  use FnLoadTester.Stats

  def calculate(data), do: FnLoadTester.Stats.Percentile.percentile(data, 50)
  def units(), do: :nanosecond
  def title(), do: "Percentile50"
end

defmodule FnLoadTester.Stats.Percentile90 do
  @moduledoc """
  Default Percentile 90.
  """
  use FnLoadTester.Stats

  def calculate(data), do: FnLoadTester.Stats.Percentile.percentile(data, 90)
  def units(), do: :nanosecond
  def title(), do: "Percentile90"
end

defmodule FnLoadTester.Stats.Percentile95 do
  @moduledoc """
  Default Percentile 95.
  """
  use FnLoadTester.Stats

  def calculate(data), do: FnLoadTester.Stats.Percentile.percentile(data, 95)
  def units(), do: :nanosecond
  def title(), do: "Percentile95"
end

defmodule FnLoadTester.Stats.Percentile99 do
  @moduledoc """
  Default Percentile 99.
  """
  use FnLoadTester.Stats

  def calculate(data), do: FnLoadTester.Stats.Percentile.percentile(data, 99)
  def units(), do: :nanosecond
  def title(), do: "Percentile99"
end
