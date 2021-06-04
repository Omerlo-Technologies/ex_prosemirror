defmodule ExProsemirror.Schema do
  @moduledoc ~S"""
  Module helper for Ecto.Schema.
  """

  use Ecto.Schema
  use ExProsemirror

  import Ecto.Changeset

  @doc ~S"""
  Automatically imports ExProsemirror.Schema functions helper.

  ## Examples

      use ExProsemirror.Schema
  """
  defmacro __using__(_opts) do
    quote do
      import ExProsemirror.Schema, only: [prosemirror_field: 1]
    end
  end

  @doc ~S"""
  Helper to generate ExProsemirror ecto schema field.

  ## Examples

      schema "my_schema" do
        prosemirror_field :title
      end

      # produces

      field :title_plain, :string, virtual: true
      embeds_one :title, ExProsemirror.Schema
  """
  defmacro prosemirror_field(name) do
    quote do
      field unquote(:"#{name}_plain"), :string, virtual: true
      embeds_one unquote(name), ExProsemirror.Schema
    end
  end

  @doc false
  embedded_schema do
    embedded_prosemirror_content(doc: ExProsemirror.Block.Doc, array: true)
  end

  @doc false
  def changeset(struct_or_changeset, attrs \\ %{})

  @doc false
  # TODO MOVE AWAY
  def changeset(struct_or_changeset, attrs) when is_bitstring(attrs) do
    case Jason.decode(attrs) do
      {:ok, attrs} -> changeset(struct_or_changeset, attrs)
      _ -> %Ecto.Changeset{valid?: false, errors: [__parent__: "Could not parse data."]}
    end
  end

  @doc false
  def changeset(struct_or_changeset, attrs) when is_map(attrs) do
    struct_or_changeset
    |> cast(attrs, [])
    |> cast_prosemirror_content()
  end
end
