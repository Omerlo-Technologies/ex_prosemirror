defmodule ExProsemirror.EctoHelper do
  import PolymorphicEmbed, only: [cast_polymorphic_embed: 2]

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
