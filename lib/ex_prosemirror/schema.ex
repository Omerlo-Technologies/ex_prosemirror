defmodule ExProsemirror.Schema do
  @moduledoc ~S"""
  Module helper for Ecto.Schema.
  """

  @doc ~S"""
  Automatically imports ExProsemirror.Schema functions helper.

  ## Examples

      use ExProsemirror.Schema
  """
  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      @primary_key false
      import ExProsemirror.Schema, only: [prosemirror_field: 2]
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
  defmacro prosemirror_field(name, type) do
    quote do
      field unquote(:"#{name}_plain"), :string, virtual: true
      embeds_one unquote(name), unquote(type)
    end
  end
end
