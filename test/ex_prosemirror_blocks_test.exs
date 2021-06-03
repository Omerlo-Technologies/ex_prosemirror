defmodule ExProsemirrorBlocksTest do
  use ExUnit.Case
  import Ecto.Changeset

  alias ExProsemirror.Block.{Heading, Image, Paragraph, Text}

  setup do
    custom_text = Ecto.UUID.generate()

    text = %{
      attr: %{type: :text, text: custom_text},
      struct: %Text{text: custom_text}
    }

    {:ok, %{text: text}}
  end

  test "paragraph", %{text: text} do
    paragraph =
      %Paragraph{}
      |> Paragraph.changeset(%{content: [text.attr]})
      |> apply_changes()

    assert paragraph == %Paragraph{content: [text.struct]}
  end

  test "heading", %{text: text} do
    heading =
      %Heading{}
      |> Heading.changeset(%{content: [text.attr], attrs: %{level: 1}})
      |> apply_changes()

    assert heading == %Heading{
             content: [text.struct],
             attrs: %Heading.Attrs{level: 1}
           }
  end

  test "image" do
    image =
      %Image{}
      |> Image.changeset(%{type: :image, attrs: %{src: "image-url"}})
      |> apply_changes()

    assert image == %Image{attrs: %Image.Attrs{src: "image-url"}}
  end
end
