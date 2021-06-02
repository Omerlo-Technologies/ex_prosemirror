defmodule ExProsemirrorTest do
  use ExUnit.Case
  doctest ExProsemirror
  doctest ExProsemirror.Config

  import Phoenix.HTML.Safe

  alias ExProsemirror.Node.{Doc, Heading, Paragraph, Text}

  @text_content_attrs %{type: :text, text: "hello world"}
  @text_content_data %Text{text: "hello world"}

  @simple_data_attrs %{
    content: %{
      type: :doc,
      content: [%{type: :paragraph, content: [@text_content_attrs]}]
    }
  }

  @simple_schema_data %ExProsemirror.Schema{
    content: %Doc{
      content: [
        %Paragraph{
          content: [@text_content_data]
        }
      ]
    }
  }

  @full_data_attrs %{
    content: %{
      type: :doc,
      content: [
        %{type: :paragraph, content: [@text_content_attrs]},
        %{type: :heading, attrs: %{level: 1}, content: [@text_content_attrs]}
      ]
    }
  }

  @full_schema_data %ExProsemirror.Schema{
    content: %Doc{
      content: [
        %Paragraph{content: [@text_content_data]},
        %Heading{
          content: [@text_content_data],
          attrs: %Heading.Attrs{level: 1}
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

    test "all doc schema" do
      data =
        %ExProsemirror.Schema{}
        |> ExProsemirror.Schema.changeset(@full_data_attrs)
        |> Ecto.Changeset.apply_changes()

      assert @full_schema_data = data
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
      attrs = %{content: [@text_content_attrs]}

      %Paragraph{}
      |> Paragraph.changeset(attrs)
      |> ExProsemirror.Changeset.validate_prosemirror(:content)
    end

    test "Without ExProsemirror fields" do
      data = %{}
      types = %{author_name: :string, title: :map}

      {data, types}
      |> Ecto.Changeset.cast(%{author_name: "Alexandre Lepretre"}, Map.keys(types))
      |> Ecto.Changeset.validate_required([:title, :author_name])
      |> ExProsemirror.Changeset.validate_prosemirror(:title)
    end
  end
end
