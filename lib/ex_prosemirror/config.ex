defmodule ExProsemirror.Config do
  @moduledoc ~S"""
  ExProsemirror allows an extensible configuration system.

  You could generate multiples types of configuration depending on your needs.

  E.g.

      config :ex_prosemirror,
        marks_modules: [
          # ...
        ],
        blocks_modules: [
          # ...
          heading: ExProsemirror.Block.Heading
        ],
        types: [
          title: [blocks: [{:heading, [:h1]}], marks: [], inline: true],
          subtitle: [blocks: [{:heading, [2, 3]}], marks: []]
        ]

  This will create 2 customs types:

  - `title` that allows only `h1` block without any marks and will be inline.
  - `subtitle` that allows `h2` and `h3` blocks and use default marks.

  ## Configuration

  * `blocks` (required) - array of blocks.
  * `marks` (optional, default: `[]`) - array of marks.
  * `inline` (optional, default: `false`) - define if the type is inline.

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
      [inline: true, marks: [:strong], blocks: [{:heading, [1, 2]}, :paragraph]]

  """

  def load(type) do
    if config_type = Keyword.get(load(), type) do
      put_default_types(config_type)
    else
      raise "ExProsemirror - Type \"#{type}\" not found in your configuration"
    end
  end

  @doc ~S"""
  Return if the debug mode is enable for `ex_prosemirror`.

  * `true`: all `ex_prosemirror` hidden input will be visible.
  * `false` (default value): mean hidden input stay hidden for the end user.
  """
  def debug?, do: Application.get_env(:ex_prosemirror, :debug, false)

  defp put_default_types(opts) do
    opts
    |> Keyword.put_new(:marks, [])
    |> Keyword.put_new(:blocks, [])
    |> Keyword.put_new(:inline, false)
  end
end
