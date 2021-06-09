defmodule ExProsemirror.ModifierHelper do
  @moduledoc ~S"""
  Ecto schema helper that defines multiple macros to use inside an Ecto.Schema.

  In contrast of `ExProsemirror.Schema`, this module should not be imported to your business schema.
  It **MUST** be used to create custom block / marks.

  It helps you build custom blocks / marks for `ExProsemirror`.

  > This module is automatically import if you use `ExProsemirror`.
  """

  import PolymorphicEmbed, only: [cast_polymorphic_embed: 3]

  @doc ~S"""
  Add the PolymorphicField mark in your ecto schema.

  ## Examples

        embedded_prosemirror_content([text: ExProsemirror.Block.Text])

  ## Options

  - array: boolean that defines if we could have multiple elements.

  > Use macro `ExProsemirror.SchemaHelper.embedded_prosemirror_field/3`.
  """
  defmacro embedded_prosemirror_content(mapped_types, opts \\ []) when is_list(mapped_types) do
    quote do
      embedded_prosemirror_field(:content, unquote(mapped_types), unquote(opts))
    end
  end

  @doc ~S"""
  Add the PolymorphicField mark in your ecto schema.

  The embedded_field created accepts an array of marks.

  ## Examples

        embedded_prosemirror_mark([strong: ExProsemirror.Mark.Strong])

  > Use macro `ExProsemirror.SchemaHelper.embedded_prosemirror_field/3`.
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
        on_type_not_found: :raise,
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

      # or with opts

      struct_or_changeset
      |> cast(attrs, some_fields_to_cast)
      |> cast_prosemirror_content(with: [text: {ExProsemirror.Block.Text, :changeset, [opts]}])

  Block `ExProsemirror.Block.Text` will be cast using the `changeset/3` with params

  * %ExProsemirror.Block.Text{...}
  * attrs (map of data to cast)
  * opts: opts to use in the changeset (e.g. allowed marks to cast defined in the ExProsemirror type.)

  > If a block/mark's type is not specified in the `with` opts, the `changeset/2` will be use.

  ## Options

  * `with`: define the changeset to apply, to send allowed marks we recommend
     to set this element to passed `opts`.

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
