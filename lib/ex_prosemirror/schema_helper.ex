defmodule ExProsemirror.SchemaHelper do
  @moduledoc ~S"""
  Ecto schema helper that defines multiple macros to use inside an Ecto.Schema.

  It helps you build custom blocks / marks for `ExProsemirror`.

  > This module is automatically import if you use `ExProsemirror`.
  """

  import PolymorphicEmbed, only: [cast_polymorphic_embed: 3]

  @doc ~S"""
  Add the PolymorphicField mark in your ecto schema.

  ## Examples

        embedded_prosemirror_content([text: ExProsemirror.Block.Text])

  Use macro `ExProsemirror.SchemaHelper.embedded_prosemirror_field/3`.
  """
  defmacro embedded_prosemirror_content(mapped_types, opts \\ []) when is_list(mapped_types) do
    quote do
      embedded_prosemirror_field(:content, unquote(mapped_types), unquote(opts))
    end
  end

  @doc ~S"""
  Add the PolymorphicField mark in your ecto schema.

  ## Examples

        embedded_prosemirror_mark([strong: ExProsemirror.Mark.Strong])

  Use macro `ExProsemirror.SchemaHelper.embedded_prosemirror_field/3`.
  """
  defmacro embedded_prosemirror_marks(mapped_types) when is_list(mapped_types) do
    quote do
      embedded_prosemirror_field(:marks, unquote(mapped_types), array: true)
    end
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
    %{type: field_type, on_replace: replace_action, default: default} = get_field_metadata(opts)

    quote do
      field unquote(field_name), unquote(field_type),
        types: unquote(mapped_types),
        on_replace: unquote(replace_action),
        type_field: :type,
        default: unquote(default)
    end
  end

  @doc """
  Cast prosemirror data struct.

  ## Examples

      struct_or_changeset
      |> cast(attrs, some_fields_to_cast)
      |> cast_prosemirror_content()
  """
  def cast_prosemirror_content(struct_or_changeset, opts \\ []) do
    cast_polymorphic_embed(struct_or_changeset, :content, opts)
  end

  def cast_prosemirror_marks(struct_or_changeset, opts \\ []) do
    cast_polymorphic_embed(struct_or_changeset, :marks, opts)
  end

  defp get_field_metadata(opts) do
    if Keyword.get(opts, :array) do
      %{type: {:array, PolymorphicEmbed}, on_replace: :delete, default: []}
    else
      %{type: PolymorphicEmbed, on_replace: :update, default: nil}
    end
  end
end
