defprotocol ExProsemirror.Encoder.HTML do
  @moduledoc ~S"""
  HTML encoder protocol for ExProsemirror's struct.

  ## Example of implementation

      alias ExProsemirror.Encoder.HTML, as: HTMLEncoder

      defimpl HTMLEncoder do
        def encode(struct, _opts) do
          text = Phoenix.HTML.html_escape(struct.text)

          struct.marks
          |> Enum.reverse()
          |> Enum.reduce(text, fn mark, acc ->
            HTMLEncoder.encode(mark, inner_content: acc)
          end)
        end

  """

  @doc ~S"""
  Encode the struct to html content.

  ## Options

  - `inner_content`: element to put inside the encoded block / marks.
  """

  def encode(struct, opts \\ [])
end

defimpl ExProsemirror.Encoder.HTML, for: List do
  def encode(structs, _opts) do
    Enum.map(structs, &ExProsemirror.Encoder.HTML.encode/1)
  end
end
