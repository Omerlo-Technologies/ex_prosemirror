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
      nest_modules_by_prefix: prosemirror_modifiers(),
      extras: ["guides/extends_editor.md"],
      groups_for_modules: [
        Modifiers: prosemirror_modifiers()
      ]
    ]
  end

  defp prosemirror_modifiers do
    [
      ExProsemirror.Block,
      ExProsemirror.Block.Doc,
      ExProsemirror.Block.Heading,
      ExProsemirror.Block.Image,
      ExProsemirror.Block.Paragraph,
      ExProsemirror.Block.Text,
      ExProsemirror.Mark,
      ExProsemirror.Mark.Em,
      ExProsemirror.Mark.Strong,
      ExProsemirror.Mark.Underline
    ]
  end
end
