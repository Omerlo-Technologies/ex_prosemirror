defmodule ExProsemirror.Mark do
  use ExProsemirror.Generator, kind: :marks

  @impl true
  def generate_schema(_context, _opts), do: []

  @impl true
  def generate_changeset(_schema) do
    quote do
      def changeset(struct_or_changeset, attrs \\ %{}) do
        %Ecto.Changeset{valid?: true, data: struct_or_changeset}
      end
    end
  end
end
