defmodule ExProsemirror.FormTest do
  use ExUnit.Case

  import Phoenix.HTML
  import ExProsemirror.HTML.Form

  alias Phoenix.HTML.Form

  describe "prosemirror_hidden_input/2" do
    test "without value" do
      input_html =
        %Form{data: %{}}
        |> prosemirror_hidden_input(:title)
        |> safe_to_string()

      assert input_html =~
               ~s(<input id="title_plain" name="title_plain" phx-update="ignore" type="hidden">)
    end

    test "with value" do
      input_html =
        %Form{data: %{title_plain: "hello"}}
        |> prosemirror_hidden_input(:title)
        |> safe_to_string()

      assert input_html =~
               ~s(<input id="title_plain" name="title_plain" phx-update="ignore" type="hidden" value="hello">)
    end
  end

  describe "prosemirror_editor/2" do
    test "without opts" do
      input_html =
        %Form{data: %{title_plain: "hello"}}
        |> prosemirror_editor(:title)
        |> safe_to_string()

      assert input_html =~
               ~s(<div class="ex-prosemirror" data-blocks="" data-marks="" data-target="#title" id="title")
    end

    test "with one mark" do
      input_html =
        %Form{data: %{title_plain: "hello"}}
        |> prosemirror_editor(:title, marks: [:em])
        |> safe_to_string()

      assert input_html =~
               ~s(<div class="ex-prosemirror" data-blocks="" data-marks="em" data-target="#title" id="title")
    end

    test "with 2 marks" do
      input_html =
        %Form{data: %{title_plain: "hello"}}
        |> prosemirror_editor(:title, marks: [:em, :strong])
        |> safe_to_string()

      assert input_html =~
               ~s(<div class="ex-prosemirror" data-blocks="" data-marks="em,strong" data-target="#title" id="title")
    end
  end

  describe "test prosemirror_input" do
    test "without options" do
      form = %Form{data: %{title_plain: "hello"}}

      inputs_html =
        form
        |> ExProsemirror.HTML.Form.prosemirror_input(:title)
        |> Phoenix.HTML.safe_to_string()

      hidden_input_html =
        form
        |> prosemirror_hidden_input(:title)
        |> safe_to_string()

      editor_input_html =
        form
        |> prosemirror_editor(:title)
        |> safe_to_string()

      assert inputs_html =~ hidden_input_html
      assert inputs_html =~ editor_input_html
    end
  end
end
