# FnLoadTester

[![hex.pm](https://img.shields.io/hexpm/v/fn_load_tester.svg?style=flat-square)](https://hex.pm/packages/fn_load_tester) [![hexdocs.pm](https://img.shields.io/badge/docs-latest-green.svg?style=flat-square)](https://hexdocs.pm/fn_load_tester/) [![Build Status](https://travis-ci.org/mendrugory/fn_load_tester.svg?branch=master)](https://travis-ci.org/mendrugory/fn_load_tester)

`FnLoadTester` is a helper tool to execute load tests against your functions, especially your `GenServer`s, and calculate statistics of the test.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `fn_load_tester` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:fn_load_tester, "~> 0.1.0", only: :dev}
  ]
end
```

## Stats

`FnLoadTester` brings some basic statistics but it also gives you the possibility of adding your own statistics.

To Build a new `Stats` it is only necessary to `use FnLoadTester.Stats` and implement the callbacks:

* calculate(list): the input is a list of times and the output has to be a number.
* units(): The outpus has to be an atom which indicates the unit of the output of calculate:
  * :nanosecond
  * :microsecond
  * :millisecond
  * :second
* title(): The output will be a string with the _Title_ of the statistics.

  ```elixir
    defmodule MyMaximum do
      use FnLoadTester.Stats

      def calculate(data), do: Enum.max(data)
      def units(), do: :nanosecond
      def title(), do: "My Maximum"
    end
  ```

In order to have more information, check the module `FnLoadTester.Stats`

## Execution

In order to execute the load test you only have to specify the number of parallel clients that will execute the given function and the number of requests per client. The fourth argument (optional) is the statistics that will be calculated.

  ```elixir
    iex> FnLoadTester.request(1, 100, fn -> MyGenServer.execute() end)
    Maximum:                104610  ns
    Minimum:                20123   ns
    Average:                26940   ns
    Percentile50:           21877   ns
    Percentile90:           36460   ns
    Percentile95:           50784   ns
    Percentile99:           104610  ns
    :ok
  ```

  ```elixir
    iex> FnLoadTester.request(1, 100, fn -> MyGenServer.execute() end, [FnLoadTester.Stats.Maximum, FnLoadTester.Stats.Minimum])
    Maximum:                104610  ns
    Minimum:                20123   ns
    :ok
  ```


## Test

  ```bash
  mix test
  ```