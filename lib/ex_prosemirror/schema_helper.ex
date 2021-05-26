defmodule ExProsemirror.SchemaHelper do
  @moduledoc ~S"""
  Ecto schema helper that defines multiple macros to use inside an Ecto.Schema.

  It helps you build custom blocks / marks for `ExProsemirror`.

  > This module is automatically import if you use `ExProsemirror`.
  """

  import PolymorphicEmbed, only: [cast_polymorphic_embed: 2]

  @doc ~S"""
  Add the PolymorphicField in your ecto schema.

  ## Examples

  Single element

      embedded_prosemirror_field([text: ExProsemirror.Text], array: false)
      # same as
      embedded_prosemirror_field([text: ExProsemirror.Text])

  Multiple elements

      embedded_prosemirror_field([text: ExProsemirror.Text], array: true)

  ## Options

  - `array`: boolean

  The `array` option will configure PolymorphicEmbed automatically to be a list of your data OR a single element.
  """
  defmacro embedded_prosemirror_field(mapped_types, opts \\ []) when is_list(mapped_types) do
    %{type: field_type, on_replace: replace_action} = get_field_metadata(opts)

    quote do
      field :content, unquote(field_type),
        types: unquote(mapped_types),
        on_type_not_found: :raise,
        on_replace: unquote(replace_action),
        type_field: :type
    end
  end

  @doc """
  Cast prosemirror data struct.

  ## Examples

      struct_or_changeset
      |> cast(attrs, some_fields_to_cast)
      |> cast_prosemirror_fields()
  """
  def cast_prosemirror_fields(struct_or_changeset) do
    cast_polymorphic_embed(struct_or_changeset, :content)
  end

  defp get_field_metadata(opts) do
    if Keyword.get(opts, :array) do
      %{type: {:array, PolymorphicEmbed}, on_replace: :delete}
    else
      %{type: PolymorphicEmbed, on_replace: :update}
    end
  end
end
