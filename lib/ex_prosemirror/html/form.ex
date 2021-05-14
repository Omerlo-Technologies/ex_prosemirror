defmodule ExProsemirror.HTML.Form do
  @moduledoc """
  Form helper to generate HTML field required by prosemirror. Using this
  component, prosemirror will automatically be link to hidden input form.
  Thoses hidden inputs will be use by `Phoenix.HTML.Form` to send data to
  the backend.

  > Live synchronization over LiveView is not currently supported.

  ## Options

  - marks: uses marks tag use defined in prosemirror config
  - blocks: uses blocks tag use defined in prosemirror config
  """

  import Phoenix.HTML
  import Phoenix.HTML.Form
  import Phoenix.HTML.Tag

  @doc ~S"""
  Generate input for Prosemirror.

  ## Usages

      <%= prosemirror_input @form, :body, id: "my-article-input" %>

  iex> prosemirror_input(form, :body)
  """
  def prosemirror_input(form, field, opts \\ []) do
    {class, opts} =
      opts
      |> Keyword.put_new(:id, input_id(form, field))
      |> Keyword.put_new(:name, input_name(form, field))
      |> Keyword.pop_values(:class)

    content_tag(
      :div,
      [
        prosemirror_hidden_input(form, field, opts),
        prosemirror_editor(form, field, opts)
      ],
      class: class
    )
  end

  @doc ~S"""
  Generate an hidden input field to store the data of prosemirror.

  > Use `Phoenix.HTML.Form.html.hidden_input/3` under the hood.

  ## Usage

      <%= prosemirror_hidden_input(@form, :title) %>
  """
  def prosemirror_hidden_input(form, field, opts \\ []) do
    opts = Keyword.take(opts, [:id, :name, :value])
    hidden_input(form, field, opts)
  end

  @doc ~S"""
  Generate the div for prosemirror that will be use by the javascript to mount
  the prosemirror component.

  ## Usage

      <%= prosemirror_editor(@form, :title) %>


  See `ExProsemirror.HTML.Form` for options

  """
  def prosemirror_editor(form, field, opts \\ []) do
    opts = Keyword.delete(opts, :value)
    {marks, opts} = Keyword.pop_values(opts, :marks)
    {blocks, opts} = Keyword.pop_values(opts, :blocks)
    {data, opts} = Keyword.pop_values(opts, :data)

    data =
      data
      |> Keyword.put(:marks, to_html_data(marks))
      |> Keyword.put(:blocks, to_html_data(blocks))
      |> Keyword.put(:target, "##{Keyword.get(opts, :id)}")

    input_id(form, field)

    opts =
      opts
      |> format_opts(:id, input_id(form, field))
      |> Keyword.put_new(:class, "ex-prosemirror")

    {value, opts} = Keyword.pop(opts, :value, input_value(form, field))

    opts = Keyword.put(opts, :data, data)

    content_tag(:div, ["\n", html_escape(value || "")], opts)
  end

  defp format_opts(opts, opt_name, default, prefix \\ "prose") when is_atom(opt_name) do
    Keyword.update(opts, opt_name, default, &:"#{&1}_#{prefix}")
  end

  defp to_html_data(values) when is_list(values) do
    values |> List.flatten() |> Enum.join(",")
  end
end
