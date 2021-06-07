defmodule ExProsemirror.Node do
  use ExProsemirror.Generator, kind: :nodes

  @impl true
  def generate_schema(context, opts) do
    [
      marks: generate_marks_fields(opts, context),
      content: generate_content_fields(opts, context)
    ]
  end

  @impl true
  def generate_changeset(schema) do
    ExProsemirror.ChangesetGenerator.generate(schema)
  end
end
