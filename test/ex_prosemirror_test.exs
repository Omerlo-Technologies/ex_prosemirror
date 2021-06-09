defmodule ExProsemirrorTest do
  use ExUnit.Case
  doctest ExProsemirror
  doctest ExProsemirror.Config

  import Phoenix.HTML.Safe

  alias ExProsemirror.Block.{Paragraph, Text}
  alias ExProsemirror.Type.BlocksOnly

  @simple_text %{
    attr: %{type: "text", text: "hello world"},
    struct: %Text{text: "hello world"}
  }

  @simple_data_attrs %{
    type: "doc",
    content: [%{type: "p", content: [@simple_text.attr]}]
  }

  @simple_schema_data %BlocksOnly{
    type: "doc",
    content: [
      %Paragraph{
        content: [@simple_text.struct]
      }
    ]
  }

  describe "test schema" do
    test "Title" do
      data =
        %BlocksOnly{}
        |> BlocksOnly.changeset(@simple_data_attrs)
        |> Ecto.Changeset.apply_changes()

      assert @simple_schema_data = data
    end

    test "Test text extract" do
      assert ExProsemirror.extract_simple_text(@simple_schema_data) == [["hello world"]]
    end
  end

  describe "Test phoenix side" do
    test "Basic HTML safe" do
      assert to_iodata(@simple_schema_data) ==
               ExProsemirror.extract_simple_text(@simple_schema_data)
    end
  end

  describe "Error management" do
    test "test" do
      attrs = %{content: [@simple_text.attr]}

      paragraph =
        %Paragraph{}
        |> Paragraph.changeset(attrs)
        |> ExProsemirror.Changeset.validate_prosemirror(:content)

      assert paragraph.valid?
    end

    test "Without ExProsemirror fields" do
      data = %{}
      types = %{author_name: :string, title: :map}

      changeset =
        {data, types}
        |> Ecto.Changeset.cast(%{author_name: "Alexandre Lepretre"}, Map.keys(types))
        |> Ecto.Changeset.validate_required([:title, :author_name])
        |> ExProsemirror.Changeset.validate_prosemirror(:title)

      refute changeset.valid?
      assert changeset.errors == [title: {"can't be blank", [validation: :required]}]
    end
  end
end
