defmodule ExProsemirror.Type do
  use ExProsemirror.Generator, kind: :types

  @impl true
  def generate_schema(context, opts) do
    [
      content: generate_content_fields(opts, context)
    ]
  end

  @impl true
  def generate_changeset(schema) do
    ExProsemirror.ChangesetGenerator.generate(schema)
  end
end
