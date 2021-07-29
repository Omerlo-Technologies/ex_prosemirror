defmodule ExProsemirror.HTML do
  @moduledoc ~S"""
  HTML management of ex_prosemirror.
  """

  import Phoenix.HTML.Tag, only: [content_tag: 2]
  import ExProsemirror.Encoder.HTML, only: [encode: 1]

  @doc ~S"""
  Render a type to an html element.
  """
  def html_safe(nil), do: content_tag(:div, nil)

  def html_safe(ex_prosemirror_type) do
    content_tag(
      :div,
      encode(ex_prosemirror_type.content)
    )
  end
end
