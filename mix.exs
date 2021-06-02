defmodule ExProsemirror.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_prosemirror,
      version: "0.1.3",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_html, "~> 2.14"},
      {:ecto, "~> 3.6"},
      {:polymorphic_embed, "~> 1.6"},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.24.2", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "ExProsemirror",
      groups_for_modules: [
        "ExProsemirror modifiers": prosemirror_modules()
      ]
    ]
  end

  defp prosemirror_modules do
    [
      ExProsemirror.Doc,
      ExProsemirror.Text,
      ExProsemirror.Heading,
      ExProsemirror.Paragraph
    ]
  end
end
