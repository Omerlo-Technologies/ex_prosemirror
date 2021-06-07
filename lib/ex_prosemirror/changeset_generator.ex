defmodule ExProsemirror.ChangesetGenerator do
  def generate(schema) do
    generate(schema[:content], schema[:marks])
  end

  def generate(_content = nil, _marks = nil) do
    quote do
      def changeset(struct_or_changeset, attrs \\ %{}) do
        cast(struct_or_changeset, attrs, [])
      end
    end
  end

  def generate(_content, _marks = nil) do
    quote do
      def changeset(struct_or_changeset, attrs \\ %{}) do
        struct_or_changeset
        |> cast(attrs, [])
        |> cast_prosemirror_content()
      end
    end
  end

  def generate(_content = nil, _marks) do
    quote do
      def changeset(struct_or_changeset, attrs \\ %{}) do
        struct_or_changeset
        |> cast(attrs, [])
        |> cast_prosemirror_marks()
      end
    end
  end

  def generate(_content, _marks) do
    quote do
      def changeset(struct_or_changeset, attrs \\ %{}) do
        struct_or_changeset
        |> cast(attrs, [])
        |> cast_prosemirror_marks()
        |> cast_prosemirror_content()
      end
    end
  end
end
