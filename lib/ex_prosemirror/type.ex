defmodule ExProsemirror.Type do
  @moduledoc ~S"""
  ExProsemirror's type helpers.
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

  @doc """
  Json the specified prosemirror type.
  """
  @spec to_json(ex_prosemirror_type :: struct) :: {:ok, String.t()} | {:error, String.t()}
  def to_json(ex_prosemirror_type) do
    ex_prosemirror_type
    |> encode()
    |> Jason.encode()
  end

  @doc """
  See `to_json/1`
  """
  def to_json!(ex_prosemirror_type) do
    ex_prosemirror_type
    |> encode()
    |> Jason.encode!()
  end

  @doc false
  def encode(ex_prosemirror_type) do
    # TODO this function should be a protocol !
    context = get_context()

    %{
      content: Enum.map(ex_prosemirror_type.content, &encode(&1, context)),
      type: ex_prosemirror_type.type
    }
  end

  def encode(elements, context) when is_list(elements) do
    Enum.map(elements, &encode(&1, context))
  end

  def encode(element, context) do
    type = context[:blocks][element.__struct__] || raise "Invalid configuration"

    element
    |> Map.drop([:content, :marks, :__struct__])
    |> Map.put(:type, type)
    |> maybe_content_to_json(element, context)
    |> maybe_marks_to_json(element, context)
  end

  defp maybe_content_to_json(result, element, context) do
    if content = Map.get(element, :content) do
      Map.put(result, :content, encode(content, context))
    else
      result
    end
  end

  defp maybe_marks_to_json(result, element, context) do
    if marks = Map.get(element, :marks) do
      types = context[:marks]

      marks =
        Enum.map(marks, fn mark ->
          type = types[mark.__struct__]

          mark
          |> Map.from_struct()
          |> Map.put(:type, type)
        end)
        |> Enum.filter(& &1.type)

      Map.put(result, :marks, marks)
    else
      result
    end
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
