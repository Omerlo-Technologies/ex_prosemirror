defmodule ExProsemirror.Block.HardBreak do
  @moduledoc ~S"""
  HardBreak blocks only contain nothing


  ## JS Interop

  When inserting an HardBreak block, `ex_prosemirror` will ... just do it.


  """

  use ExProsemirror.Schema
  use ExProsemirror.Encoder.Json, type: :br

  @type t :: %__MODULE__{
        }

  @doc false
  embedded_schema do
  end

  @doc false
  def changeset(struct_or_changeset, _attrs \\ %{}) do
    struct_or_changeset
  end

  defimpl ExProsemirror.Encoder.HTML do
    import Phoenix.HTML.Tag
    def encode(_, _inner_content) do
      tag("br")
    end
  end
end
