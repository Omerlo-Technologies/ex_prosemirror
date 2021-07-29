defmodule ExProsemirror.Encoder.HTMLTest do
  @moduledoc false
  use ExUnit.Case

  import Phoenix.HTML

  alias ExProsemirror.Block.{Heading, Image, Paragraph, Text}
  alias ExProsemirror.Encoder.HTML, as: HTMLEncoder
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
        |> HTMLEncoder.encode()
        |> safe_to_string()

      assert header == "<h1>Hello folks</h1>"
    end

    test "encode paragraph" do
      paragraph =
        %Paragraph{
          content: [
            %Text{text: "Hello folks"}
          ]
        }
        |> HTMLEncoder.encode()
        |> safe_to_string()

      assert paragraph == "<p>Hello folks</p>"
    end

    test "encode image" do
      img =
        %Image{attrs: %Image.Attrs{src: "url", title: "title", alt: "An alt"}}
        |> HTMLEncoder.encode()
        |> safe_to_string()

      assert img == ~s(<img alt="An alt" src="url">)
    end

    test "encode text" do
      text = %Text{text: "Hello folks"} |> HTMLEncoder.encode() |> safe_to_string()
      assert text == "Hello folks"
    end

    test "encode text with special chars" do
      text = %Text{text: "<p>Hello folks</p>"} |> HTMLEncoder.encode() |> safe_to_string()
      assert text == "&lt;p&gt;Hello folks&lt;/p&gt;"
    end
  end

  describe "marks" do
    test "em" do
      text =
        %Text{text: "Hello folks", marks: [%Em{}]} |> HTMLEncoder.encode() |> safe_to_string()

      assert text == "<em>Hello folks</em>"
    end

    test "strong" do
      text =
        %Text{text: "Hello folks", marks: [%Strong{}]}
        |> HTMLEncoder.encode()
        |> safe_to_string()

      assert text == "<strong>Hello folks</strong>"
    end

    test "em then strong" do
      text =
        %Text{text: "Hello folks", marks: [%Em{}, %Strong{}]}
        |> HTMLEncoder.encode()
        |> safe_to_string()

      assert text == "<em><strong>Hello folks</strong></em>"
    end

    test "strong then em" do
      text =
        %Text{text: "Hello folks", marks: [%Strong{}, %Em{}]}
        |> HTMLEncoder.encode()
        |> safe_to_string()

      assert text == "<strong><em>Hello folks</em></strong>"
    end

    test "strikethrough" do
      text =
        %Text{text: "Hello folks", marks: [%Strikethrough{}]}
        |> HTMLEncoder.encode()
        |> safe_to_string()

      assert text == "<del>Hello folks</del>"
    end

    test "underline" do
      text =
        %Text{text: "Hello folks", marks: [%Underline{}]}
        |> HTMLEncoder.encode()
        |> safe_to_string()

      assert text == ~s(<span style="text-decoration: underline;">Hello folks</span>)
    end

    test "color" do
      text =
        %Text{text: "Hello folks", marks: [%Color{attrs: %Color.Attrs{color: "red"}}]}
        |> HTMLEncoder.encode()
        |> safe_to_string()

      assert text == ~s(<span style="color: red;">Hello folks</span>)
    end

    test "text family" do
      text =
        %Text{
          text: "Hello folks",
          marks: [%FontFamily{attrs: %FontFamily.Attrs{font_family: "sans-serif"}}]
        }
        |> HTMLEncoder.encode()
        |> safe_to_string()

      assert text == ~s(<span style="font-family: &quot;sans-serif;&quot;">Hello folks</span>)
    end

    test "link" do
      href = "http://a-random-url.com/"

      text =
        %Text{
          text: "Hello folks",
          marks: [%Link{attrs: %Link.Attrs{title: "My link", href: href}}]
        }
        |> ExProsemirror.Encoder.HTML.encode()
        |> safe_to_string()

      assert text == ~s(<a href="#{href}">Hello folks</a>)
    end
  end
end
