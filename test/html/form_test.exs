defmodule ExProsemirror.HTML.FormTest do
  use ExUnit.Case

  import Phoenix.HTML
  import ExProsemirror.HTML.Form

  alias Phoenix.HTML.Form

  describe "prosemirror_hidden_input/2" do
    test "without value" do
      input_html =
        %Form{data: %{}}
        |> prosemirror_hidden_input(:title, type: :empty)
        |> safe_to_string()

      assert input_html =~
               ~s(<input id="title_plain" name="title_plain" phx-update="ignore" type="hidden">)
    end

    test "with value" do
      input_html =
        %Form{data: %{title_plain: "hello"}}
        |> prosemirror_hidden_input(:title, type: :empty)
        |> safe_to_string()

      assert input_html =~
               ~s(<input id="title_plain" name="title_plain" phx-update="ignore" type="hidden" value="hello">)
    end
  end

  describe "prosemirror_editor/2" do
    test "no marks - no blocks" do
      input_html =
        %Form{data: %{title_plain: "hello"}}
        |> prosemirror_editor(:title, type: :empty)
        |> safe_to_string()

      assert input_html =~ ~s(data-blocks="[]")
      assert input_html =~ ~s(data-marks="[]")
    end

    test "marks only" do
      input_html =
        %Form{data: %{title_plain: "hello"}}
        |> prosemirror_editor(:title, type: :marks_only)
        |> safe_to_string()

      assert input_html =~ ~s(data-blocks="[]")
      assert input_html =~ ~s(data-marks="[{&quot;type&quot;:&quot;em&quot;}]")
    end

    test "blocks only" do
      input_html =
        %Form{data: %{title_plain: "hello"}}
        |> prosemirror_editor(:title, type: :blocks_only)
        |> safe_to_string()

      assert input_html =~ ~s(data-blocks="[{&quot;type&quot;:&quot;paragraph&quot;}]")
      assert input_html =~ ~s(data-marks="[]")
    end
  end

  @tag capture_log: true
  describe "defaults" do
    test "unknow type" do
      func = fn ->
        %Form{data: %{title_plain: "hello"}}
        |> prosemirror_editor(:title, type: :unknown)
      end

      assert_raise(
        RuntimeError,
        ~S(ExProsemirror - Type "unknown" not found in your configuration),
        func
      )
    end
  end
end
