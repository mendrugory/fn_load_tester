defmodule FnLoadTester.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :fn_load_tester,
      version: @version,
      elixir: "~> 1.6",
      package: package(),
      description: "FnLoadTester is a helper tool to execute load tests against your functions, especially your GenServers, and calculate statistics of the test",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        main: "readme",
        source_ref: "v#{@version}",
        extras: ["README.md"],
        source_url: "https://github.com/mendrugory/piton"
]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  
  defp deps do
    []
  end

  defp package() do
    %{
      licenses: ["MIT"],
      maintainers: ["Gonzalo Jiménez Fuentes"],
      links: %{"GitHub" => "https://github.com/mendrugory/fn_load_tester"}
    }
end  
end
