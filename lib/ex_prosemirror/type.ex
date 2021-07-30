defmodule ExProsemirror.Type do
  @moduledoc ~S"""
  ExProsemirror's type helpers.

  A type is composed by `blocks` and `marks`. Those elements defined what is
  allowed in your type.

  ## E.g

      types: [
        title: [
          blocks: [{:heading, [1, 3]}],
          marks: [:strong]
        ]
      ]

  This will createa type `title` defined by the module `ExProsemirror.Type.Title`.
  This type will allow `h1` and `h3` blocks but also the mark `strong`.

  `blocks` and `marks` follow the same rules, you can defined them simply with
  the element name OR with the tuple `{element_name, attrs}` when attrs depends
  of the element.

  > You can take a look at `ExProsemirror.Mark.Color` or
  > `ExProsemirror.Block.Heading` for examples).

  As you can see previously, element `heading` allow attrs `1` and `3` that could
  be translate as level `1` or level `3` (`h1` or `h3`).
  """

  import Ecto.Changeset
  import ExProsemirror.ModifierHelper

  require ExProsemirror.TypeGenerator
  ExProsemirror.TypeGenerator.generate_all()

  @doc """
  Changeset used by all `ExProsemirror.Type`.
  """
  def changeset(struct_or_changeset, attrs \\ %{}, opts \\ []) do
    struct_or_changeset
    |> cast(attrs, [])
    |> cast_prosemirror_content(opts)
    |> maybe_force_inline(opts[:inline])
  end

  defp maybe_force_inline(changeset, false), do: changeset

  defp maybe_force_inline(changeset, true) do
    update_change(changeset, :content, fn content ->
      case content do
        [content | _] -> [content]
        _ -> []
      end
    end)
  end

  @doc ~S"""
  Returns context to use for ExProsemirror types.

  ## Examples

      ExProsemirror.TypeGenerator.get_context()
      [
        marks: [
          em: ExProsemirror.Mark.Em,
          strong: ExProsemirror.Mark.Strong,
          underline: ExProsemirror.Mark.Underline
        ],
        blocks: [
          p: ExProsemirror.Block.Paragraph,
          heading: ExProsemirror.Block.Heading,
          image: ExProsemirror.Block.Image,
          text: ExProsemirror.Block.Text
        ]
      ]
  """
  def get_context do
    ExProsemirror.TypeGenerator.get_context()
    |> Enum.map(fn {k, v} ->
      {k, Enum.map(v, fn {k, v} -> {v, k} end)}
    end)
  end
end
