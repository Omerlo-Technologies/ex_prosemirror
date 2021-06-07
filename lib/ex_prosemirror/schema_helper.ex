defmodule ExProsemirror.SchemaHelper do
  @moduledoc ~S"""
  Ecto schema helper that defines multiple macros to use inside an Ecto.Schema.

  It helps you build custom blocks / marks for `ExProsemirror` and override allowed blocks / marks
  using the config system.

  ## Examples

  You can add a new mark `custom_span` by mapping the type to your module. And to remove
  a default block, you have to set his value to `nil`.

  ```elixir
  config :ex_prosemirror
    # ...
    schema: [
      "ExProsemirror.Block.Text": [
        marks: [
          custom_span: MyApp.Block.MySpan,
          strong: nil
        ]
      ]
    ]
  ```

  This works at the same way for blocks.

  ```elixir
  config :ex_prosemirror
    # ...
    schema: [
      "ExProsemirror.Block.Text": [
        blocks: [
          image: MyApp.Block.Image,
        ]
      ]
    ]
  ```

  > This module is automatically import if you use `ExProsemirror`.
  """

  @schema Application.compile_env(:ex_prosemirror, :schema, [])

  import PolymorphicEmbed, only: [cast_polymorphic_embed: 2]

  @doc ~S"""
  Add the PolymorphicField mark in your ecto schema.

  ## Examples

        embedded_prosemirror_content([text: ExProsemirror.Block.Text])

  Use macro `ExProsemirror.SchemaHelper.embedded_prosemirror_field/3`.
  """
  defmacro embedded_prosemirror_content(default_blocks, opts \\ [])
           when is_list(default_blocks) do
    blocks =
      __CALLER__
      |> module_config_name()
      |> polymorphic_fields(:blocks, default_blocks)

    quote do
      embedded_prosemirror_field(:content, unquote(blocks), unquote(opts))
    end
  end

  @doc ~S"""
  Add the PolymorphicField mark in your ecto schema.

  ## Examples

        embedded_prosemirror_mark([strong: ExProsemirror.Mark.Strong])

  Use macro `ExProsemirror.SchemaHelper.embedded_prosemirror_field/3`.
  """
  defmacro embedded_prosemirror_marks(default_marks) when is_list(default_marks) do
    marks =
      __CALLER__
      |> module_config_name()
      |> polymorphic_fields(:marks, default_marks)

    quote do
      embedded_prosemirror_field(:marks, unquote(marks), array: true)
    end
  end

  defp module_config_name(caller) do
    caller.module
    |> Module.split()
    |> Enum.join(".")
    |> String.to_atom()
  end

  defp polymorphic_fields(module_name, type, base_config) do
    (@schema[module_name][type] || [])
    |> Enum.reduce(base_config, fn {name, module}, acc ->
      Keyword.put(acc, name, module)
    end)
    |> Enum.filter(& &1)
  end

  @doc ~S"""
  Add the PolymorphicField in your ecto schema.

  ## Examples

  Single element

      embedded_prosemirror_field(:content, [text: ExProsemirror.Block.Text], array: false)
      # same as
      embedded_prosemirror_field(:content, [text: ExProsemirror.Block.Text])

  Multiple elements

      embedded_prosemirror_field(:content, [text: ExProsemirror.Block.Text], array: true)

  ## Options

  - `array`: boolean

  The `array` option will configure PolymorphicEmbed automatically to be a list of your data OR a single element.
  """
  @spec embedded_prosemirror_field(:content | :marks, [module()], array: boolean) :: term()
  defmacro embedded_prosemirror_field(field_name, mapped_types, opts \\ [])
           when is_list(mapped_types) and is_atom(field_name) do
    %{type: field_type, on_replace: replace_action} = get_field_metadata(opts)

    quote do
      field unquote(field_name), unquote(field_type),
        types: unquote(mapped_types),
        on_replace: unquote(replace_action),
        type_field: :type
    end
  end

  @doc """
  Cast prosemirror data struct.

  ## Examples

      struct_or_changeset
      |> cast(attrs, some_fields_to_cast)
      |> cast_prosemirror_content()
  """
  def cast_prosemirror_content(struct_or_changeset) do
    cast_polymorphic_embed(struct_or_changeset, :content)
  end

  def cast_prosemirror_marks(struct_or_changeset) do
    cast_polymorphic_embed(struct_or_changeset, :marks)
  end

  defp get_field_metadata(opts) do
    if Keyword.get(opts, :array) do
      %{type: {:array, PolymorphicEmbed}, on_replace: :delete}
    else
      %{type: PolymorphicEmbed, on_replace: :update}
    end
  end
end
