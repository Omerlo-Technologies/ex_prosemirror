defmodule ExProsemirror.Config do
  @moduledoc ~S"""
  ExProsemirror allows an extensible configuration system.

  You could generate multiples types of configuration depending on your needs.

  E.g.

      config :ex_prosemirror,
        types: [
          title: [blocks: [:h1], marks: []],
          subtitle: [blocks: [:h2, :h3]]
        ]

  This will create 2 customs types:

  - `title` that allows only `h1` block without any marks
  - `subtitle` that allows `h2` and `h3` blocks and use default marks.

  If there is no default configuration, then everything is allowed.

  To override `default`, you can add a `default` config for `ex_prosemirror`.

  E.g

      config :ex_prosemirror,
        default: [
          marks: [:em],
          blocks: [:p, :h1]
        ]

  This will set default marks to `em` only and `blocks` to `p` and `h1`.
  """

  require Logger

  @doc ~S"""
  Get the configuration of ExProsemirror
  """
  def load do
    Application.get_env(:ex_prosemirror, :types, [])
  end

  @doc ~S"""
  Get the configuration for the specified type.

  ## Examples

      iex> ExProsemirror.Config.load(:title)
      [inline: true, marks: [:strong], blocks: [{:heading, [:h1, :h2]}, :p]]

  """

  def load(type) do
    if config_type = Keyword.get(load(), type) do
      put_default_types(config_type)
    else
      Logger.warn(fn ->
        "ExProsemirror - Type \"#{type}\" not found in your configuration, using default."
      end)

      put_default_types()
    end
  end

  def debug?, do: Application.get_env(:ex_prosemirror, :debug, false)

  defp put_default_types(opts \\ []) do
    opts
    |> Keyword.put_new(:marks, [])
    |> Keyword.put_new(:blocks, [])
    |> Keyword.put_new(:inline, false)
  end
end
