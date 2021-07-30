defmodule ExProsemirror.Encoder.JsonTest do
  @moduledoc false
  use ExUnit.Case

  alias ExProsemirror.Block.{Heading, Image, Paragraph, Text}
  alias ExProsemirror.Mark.{Color, Em, FontFamily, Link, Strikethrough, Strong, Underline}

  describe "blocks" do
    test "encode header" do
      header =
        %Heading{
          content: [
            %Text{text: "Hello folks"}
          ],
          attrs: %Heading.Attrs{level: 1}
        }
        |> Jason.encode!()
        |> Jason.decode!()

      assert %{
               "attrs" => %{"level" => 1},
               "content" => [%{"marks" => [], "text" => "Hello folks", "type" => "text"}],
               "type" => "heading"
             } = header
    end

    test "encode paragraph" do
      paragraph =
        %Paragraph{
          content: [
            %Text{text: "Hello folks"}
          ]
        }
        |> Jason.encode!()
        |> Jason.decode!()

      assert %{
               "content" => [%{"marks" => [], "text" => "Hello folks", "type" => "text"}],
               "type" => "paragraph"
             } = paragraph
    end

    test "encode image" do
      img =
        %Image{attrs: %Image.Attrs{src: "url", title: "title", alt: "An alt"}}
        |> Jason.encode!()
        |> Jason.decode!()

      assert %{
               "attrs" => %{"alt" => "An alt", "src" => "url", "title" => "title"},
               "type" => "image"
             } = img
    end

    test "encode text" do
      text = %Text{text: "Hello folks"} |> Jason.encode!() |> Jason.decode!()
      assert %{"marks" => [], "text" => "Hello folks", "type" => "text"} = text
    end
  end

  describe "marks" do
    test "em" do
      text =
        %Text{text: "Hello folks", marks: [%Em{}]}
        |> Jason.encode!()
        |> Jason.decode!()

      assert %{"marks" => [%{"type" => "em"}], "text" => "Hello folks", "type" => "text"} = text
    end

    test "strong" do
      text =
        %Text{text: "Hello folks", marks: [%Strong{}]}
        |> Jason.encode!()
        |> Jason.decode!()

      assert %{
               "marks" => [%{"type" => "strong"}],
               "text" => "Hello folks",
               "type" => "text"
             } = text
    end

    test "em then strong" do
      text =
        %Text{text: "Hello folks", marks: [%Em{}, %Strong{}]}
        |> Jason.encode!()
        |> Jason.decode!()

      assert %{
               "marks" => [%{"type" => "em"}, %{"type" => "strong"}],
               "text" => "Hello folks",
               "type" => "text"
             } = text
    end

    test "strong then em" do
      text =
        %Text{text: "Hello folks", marks: [%Strong{}, %Em{}]}
        |> Jason.encode!()
        |> Jason.decode!()

      assert %{
               "marks" => [%{"type" => "strong"}, %{"type" => "em"}],
               "text" => "Hello folks",
               "type" => "text"
             } = text
    end

    test "strikethrough" do
      text =
        %Text{text: "Hello folks", marks: [%Strikethrough{}]}
        |> Jason.encode!()
        |> Jason.decode!()

      assert %{
               "marks" => [%{"type" => "strikethrough"}],
               "text" => "Hello folks",
               "type" => "text"
             } = text
    end

    test "underline" do
      text =
        %Text{text: "Hello folks", marks: [%Underline{}]}
        |> Jason.encode!()
        |> Jason.decode!()

      assert %{"marks" => [%{"type" => "underline"}], "text" => "Hello folks", "type" => "text"} =
               text
    end

    test "color" do
      text =
        %Text{text: "Hello folks", marks: [%Color{attrs: %Color.Attrs{color: "red"}}]}
        |> Jason.encode!()
        |> Jason.decode!()

      assert %{
               "marks" => [%{"attrs" => %{"color" => "red"}, "type" => "color"}],
               "text" => "Hello folks",
               "type" => "text"
             } = text
    end

    test "text family" do
      text =
        %Text{
          text: "Hello folks",
          marks: [%FontFamily{attrs: %FontFamily.Attrs{font_family: "sans-serif"}}]
        }
        |> Jason.encode!()
        |> Jason.decode!()

      assert %{
               "marks" => [
                 %{"attrs" => %{"font_family" => "sans-serif"}, "type" => "font_family"}
               ],
               "text" => "Hello folks",
               "type" => "text"
             } = text
    end

    test "link" do
      href = "http://a-random-url.com/"

      text =
        %Text{
          text: "Hello folks",
          marks: [%Link{attrs: %Link.Attrs{title: "My link", href: href}}]
        }
        |> Jason.encode!()
        |> Jason.decode!()

      assert %{
               "marks" => [
                 %{
                   "attrs" => %{"href" => "http://a-random-url.com/", "title" => "My link"},
                   "type" => "link"
                 }
               ],
               "text" => "Hello folks",
               "type" => "text"
             } = text
    end
  end
end
