defmodule ExProsemirrorMarksTest do
  use ExUnit.Case
  import Ecto.Changeset

  alias ExProsemirror.Block.Text
  alias ExProsemirror.Mark.{Em, Strong, Underline}

  @allowed_marks [em: Em, strong: Strong, underline: Underline]

  setup do
    custom_text = Ecto.UUID.generate()

    {:ok,
     %{
       text_attrs: %{type: :text, text: custom_text},
       text_struct: %Text{text: custom_text}
     }}
  end

  setup context do
    text_attrs =
      if marks = context[:marks] do
        Map.put(context[:text_attrs], :marks, marks)
      else
        context[:text_attrs]
      end

    {:ok, Map.put(context, :text_attrs, text_attrs)}
  end

  @tag marks: [%{type: "strong"}]
  test "strong", %{text_attrs: text_attrs, text_struct: text_struct} do
    text =
      %Text{}
      |> Text.changeset(text_attrs, marks: @allowed_marks)
      |> apply_changes()

    assert text == Map.put(text_struct, :marks, [%Strong{}])
  end

  @tag marks: [%{type: "em"}]
  test "em", %{text_attrs: text_attrs, text_struct: text_struct} do
    text =
      %Text{}
      |> Text.changeset(text_attrs, marks: @allowed_marks)
      |> Ecto.Changeset.apply_changes()

    assert text == Map.put(text_struct, :marks, [%Em{}])
  end

  @tag marks: [%{type: "underline"}]
  test "underline", %{text_attrs: text_attrs, text_struct: text_struct} do
    text =
      %Text{}
      |> Text.changeset(text_attrs, marks: @allowed_marks)
      |> apply_changes()

    assert text == Map.put(text_struct, :marks, [%Underline{}])
  end

  @tag marks: [%{type: "underline"}, %{type: "strong"}]
  test "mulitples marks", %{text_attrs: text_attrs, text_struct: text_struct} do
    text =
      %Text{}
      |> Text.changeset(text_attrs, marks: @allowed_marks)
      |> apply_changes()

    assert text == Map.put(text_struct, :marks, [%Underline{}, %Strong{}])
  end

  @tag marks: [%{type: "underline"}]
  test "unallowd mark", %{text_attrs: text_attrs, text_struct: text_struct} do
    text =
      %Text{}
      |> Text.changeset(text_attrs, marks: [])
      |> apply_changes()

    assert text == text_struct
  end
end
