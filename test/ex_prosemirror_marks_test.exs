defmodule ExProsemirrorMarksTest do
  use ExUnit.Case
  import Ecto.Changeset

  alias ExProsemirror.Block.Text
  alias ExProsemirror.Mark.{Em, Strong, Underline}

  setup do
    custom_text = Ecto.UUID.generate()

    {:ok,
     %{
       text_attr: %{type: :text, text: custom_text},
       text_struct: %Text{text: custom_text}
     }}
  end

  test "strong", %{text_attr: text_attr, text_struct: text_struct} do
    text =
      %Text{}
      |> Text.changeset(Map.put(text_attr, :marks, [%{type: :strong}]))
      |> apply_changes()

    assert text == Map.put(text_struct, :marks, [%Strong{}])
  end

  test "em", %{text_attr: text_attr, text_struct: text_struct} do
    text =
      %Text{}
      |> Text.changeset(Map.put(text_attr, :marks, [%{type: :em}]))
      |> apply_changes()

    assert text == Map.put(text_struct, :marks, [%Em{}])
  end

  test "underline", %{text_attr: text_attr, text_struct: text_struct} do
    text =
      %Text{}
      |> Text.changeset(Map.put(text_attr, :marks, [%{type: :underline}]))
      |> apply_changes()

    assert text == Map.put(text_struct, :marks, [%Underline{}])
  end
end
