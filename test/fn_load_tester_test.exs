defmodule FnLoadTesterTest do
  use ExUnit.Case

  test "default stats" do
    assert FnLoadTester.request(1, 100, fn -> MyGenServer.run() end) == :ok
  end

  test "several clients" do
    assert FnLoadTester.request(100, 100, fn -> MyGenServer.run() end) == :ok
  end

  test "some stats" do
    assert FnLoadTester.request(1, 100, fn -> MyGenServer.run() end, [
             FnLoadTester.Stats.Maximum,
             FnLoadTester.Stats.Minimum
           ]) == :ok
  end

  test "custom stats" do
    defmodule MyMaximum do
      use FnLoadTester.Stats

      def calculate(data), do: Enum.max(data)
      def units(), do: :nanosecond
      def title(), do: "Maximum"
    end

    assert FnLoadTester.request(1, 100, fn -> MyGenServer.run() end, [MyMaximum]) == :ok
  end
end
