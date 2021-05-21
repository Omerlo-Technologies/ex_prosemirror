defmodule ExProsemirrorTest do
  use ExUnit.Case
  doctest ExProsemirror

  @simple_data_attrs %{
    content: %{
      type: :doc,
      content: [%{type: :paragraph, content: [%{type: :text, text: "hello"}]}]
    }
  }

  @simple_schema_data %ExProsemirror.Schema{
    content: %ExProsemirror.Doc{
      content: [
        %ExProsemirror.Paragraph{
          content: [%ExProsemirror.Text{id: nil, text: "hello"}]
        }
      ]
    }
  }

  describe "test schema" do
    test "Simple doc" do
      data =
        %ExProsemirror.Schema{}
        |> ExProsemirror.Schema.changeset(@simple_data_attrs)
        |> Ecto.Changeset.apply_changes()

      assert @simple_schema_data = data
    end
  end

  describe "Test text extract" do
    assert ExProsemirror.extract_simple_text(@simple_schema_data) == [["hello"]]
  end
end
