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

  @default_marks Application.compile_env!(:ex_prosemirror, :default_marks)
  @default_blocks Application.compile_env!(:ex_prosemirror, :default_blocks)
  @default [blocks: @default_blocks, marks: @default_marks]
  @default_inline false

  @doc ~S"""
  Override the `config` with the `input_config`.

  ## Examples

      iex> ExProsemirror.Config.override([marks: []], [marks: [em: true]])
      [marks: [:em]]

      iex> ExProsemirror.Config.override([marks: [:em]], [marks: [em: true]])
      [marks: [:em]]

      iex> ExProsemirror.Config.override([marks: [:strong]], [marks: [em: true]])
      [marks: [:em, :strong]]
  """
  def override(config, input_config) do
    config
    |> do_override(input_config, :marks)
    |> do_override(input_config, :blocks)
    |> do_override(input_config, :inline)
  end

  defp do_override(config, input_config, :inline) do
    if is_nil(Keyword.get(input_config, :inline)),
      do: config,
      else: Keyword.put(config, :inline, Keyword.get(input_config, :inline))
  end

  defp do_override(config, input_config, field) do
    if curr_config = Keyword.get(config, field) do
      curr_config = do_override_reduce(curr_config, input_config, field)
      Keyword.put(config, field, curr_config)
    else
      config
    end
  end

  defp do_override_reduce(curr_config, input_config, field) do
    input_config
    |> Keyword.get(field, [])
    |> List.flatten()
    |> Enum.reduce(MapSet.new(curr_config), fn {field_type, enabled}, config ->
      action = (enabled && :put) || :delete
      Kernel.apply(MapSet, action, [config, field_type])
    end)
    |> MapSet.to_list()
  end

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
      [blocks: [:h1, :h2], marks: [:strong]]

      iex> ExProsemirror.Config.load(:lead)
      [blocks: [:h1, :h2, :p], marks: [:em, :strong]]

      iex> ExProsemirror.Config.load(:lead, marks: [em: false])
      [blocks: [:h1, :h2, :p], marks: [:strong]]

  """
  def load(type, custom_config \\ [])

  def load(:default, custom_config) do
    put_default_types()
    |> override(custom_config)
  end

  def load(type, custom_config) do
    if config_type = Keyword.get(load(), type) do
      put_default_types(config_type)
    else
      Logger.warn(fn ->
        "ExProsemirror - Type \"#{type}\" not found in your configuration, using default."
      end)

      put_default_types()
    end
    |> override(custom_config)
  end

  def debug?, do: Application.get_env(:ex_prosemirror, :debug, false)

  defp put_default_types(opts \\ @default) do
    opts
    |> Keyword.put_new(:marks, @default_marks)
    |> Keyword.put_new(:blocks, @default_blocks)
  end
end
