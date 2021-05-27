defmodule ExProsemirror.HTML.Form do
  @moduledoc """
  Form helpers to generate HTML fields required by ProseMirror.

  Using this component, ProseMirror will automatically be link to hidden input
  fields. These hidden inputs will be used by `Phoenix.HTML.Form` to send data
  to the backend.

  > Live synchronization over LiveView is not currently supported.

  ## Options

  - marks: mark tags to use defined in your ProseMirror config
  - blocks: block tags to use defined in your ProseMirror config

  """

  import Phoenix.HTML
  import Phoenix.HTML.Form
  import Phoenix.HTML.Tag

  @doc ~S"""
  Generates inputs for ProseMirror.

  ## Usages

      <%= prosemirror_input @form, :body, id: "my-article-input" %>

  iex> prosemirror_input(form, :body)
  """
  def prosemirror_input(form, field, opts \\ []) do
    id = input_id(form, field)

    {class, opts} =
      opts
      |> Keyword.put_new(:id, id)
      |> Keyword.put_new(:name, input_name(form, field))
      |> Keyword.pop_values(:class)

    content_tag(
      :div,
      [
        prosemirror_hidden_input(form, field, opts),
        prosemirror_editor(form, field, opts)
      ],
      class: class,
      id: "#{id}_prose_root"
    )
  end

  @doc ~S"""
  Generates a hidden input field to store data for ProseMirror.

  > Uses `Phoenix.HTML.Form.html.hidden_input/3` under the hood.

  ## Usage

      <%= prosemirror_hidden_input(@form, :title) %>
  """
  def prosemirror_hidden_input(form, field, opts \\ []) do
    opts =
      opts
      |> Keyword.take([:id, :value])
      |> Keyword.put(:phx_update, "ignore")
      |> Keyword.update(:id, "#{field}_plain", fn id -> "#{id}_plain" end)

    if Application.get_env(:ex_prosemirror, :debug, false) do
      textarea(form, :"#{field}_plain", opts)
    else
      hidden_input(form, :"#{field}_plain", opts)
    end
  end

  @doc ~S"""
  Generates the `<div>` that will be used by javascript to mount the ProseMirror component.

  ## Usage

      <%= prosemirror_editor(@form, :title) %>


  See `ExProsemirror.HTML.Form` for options

  """
  def prosemirror_editor(form, field, opts \\ []) do
    opts =
      Keyword.delete(opts, :value)
      |> Keyword.put_new(:id, input_id(form, field))
      |> set_target()
      |> Keyword.put_new(:class, "ex-prosemirror")
      |> Keyword.put(:phx_update, "ignore")
      |> Keyword.put(:phx_hook, "MountProseMirror")
      |> Keyword.put_new(:name, input_name(form, field))

    {marks, opts} = Keyword.pop_values(opts, :marks)
    {blocks, opts} = Keyword.pop_values(opts, :blocks)
    {data, opts} = Keyword.pop_values(opts, :data)

    data =
      data
      |> Keyword.put(:marks, to_html_data(marks))
      |> Keyword.put(:blocks, to_html_data(blocks))
      |> Keyword.put(:target, "##{Keyword.get(opts, :id)}")

    {_value, opts} = Keyword.pop(opts, :value, input_value(form, field))

    opts = Keyword.put(opts, :data, data)

    content_tag(:div, ["\n", html_escape("")], opts)
  end

  defp set_target(opts) do
    Keyword.put(opts, :target, "##{Keyword.get(opts, :id)}")
  end

  defp to_html_data(values) when is_list(values) do
    values |> List.flatten() |> Enum.join(",")
  end
end
