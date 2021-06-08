defmodule ExProsemirror.Generator do
  @callback generate_schema(context :: keyword(), opts :: keyword()) :: any
  @callback generate_changeset(keyword()) :: any

  @optional_callbacks [generate_schema: 2, generate_changeset: 1]

  @doc ~S"""
  Define a ExProsemirror Generator.

  ## Options

  - `kind`: Kind of the generator, could be `:marks`, `:types` or `:nodes`.
    If not provided the function `generate/1` will not be add to the module.

  ## Examples

      use ExProsemirror.Generator, kind: :marks

  """
  defmacro __using__(opts) do
    quote do
      @behaviour ExProsemirror.Generator

      import unquote(__MODULE__)
      generate(unquote(opts[:kind]))
    end
  end

  @doc ~S"""
  Create a function that will generate a kind of ex_prosemirror element.
  It will use the `kind` defined when using this module.

  ## Examples

  In the `ExProsemirror.Mark` we have:

      use ExProsemirror.Generator, kind: :marks

  That will produces

      def generate(context) do
        context = Keyword.put(context, :generate, ExProsemirror.Mark)
        generate(:marks, context)
      end

  """
  defmacro generate(nil), do: nil

  defmacro generate(kind) do
    quote do
      def generate(context) do
        context = Keyword.put(context, :generator, __MODULE__)
        generate(unquote(kind), context)
      end
    end
  end

  @doc ~S"""
  Generate a kind of prosemirror element depending of a context.

  > `context` is defined in the configuration.
  """
  def generate(kind, context) do
    Enum.map(context[kind], fn {name, opts} ->
      if opts[:autogenerate] do
        {name, generate_module(context, opts)}
      else
        {name, opts[:module]}
      end
    end)
  end

  @doc ~S"""
  Create a module with the specified name. The content of the module will be generated
  depending of the specified context and opts.
  """
  def generate_module(context, opts) do
    module_name = opts[:module]
    content = module_content(context, opts)

    Module.create(module_name, content, Macro.Env.location(__ENV__))
  end

  @doc ~S"""
  Generate the module's content of an ex_prosemirror element.
  This will use `generate_schema/2` and `generate_changeset/0` defined in the generator.

  Currently generators are `ExProsemirror.Mark`, `ExProsemirror.Node` and `ExProsemirror.Type`
  """
  def module_content(context, opts) do
    module = opts[:module]
    generator = context[:generator]

    schema =
      if function_exported?(module, :generate_schema, 2) do
        module.generate_schema(context, opts)
      else
        generator.generate_schema(context, opts)
      end

    changeset =
      if function_exported?(module, :generate_changeset, 1) do
        module.generate_changeset(schema)
      else
        generator.generate_changeset(schema)
      end

    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import ExProsemirror.SchemaHelper

      embedded_schema do
        unquote(schema[:marks])
        unquote(schema[:content])
      end

      unquote(changeset)
    end
  end

  @doc ~S"""
  Generate a polymorphic schema named `:contents`.
  """
  def generate_content_fields(opts, context) do
    nodes = Keyword.get(opts, :nodes, [])

    nodes =
      context
      |> Keyword.get(:nodes, [])
      |> Keyword.take(nodes)
      |> Enum.map(fn {name, opts} -> {name, opts[:module]} end)

    quote do
      embedded_prosemirror_content(unquote(nodes), array: unquote(opts[:array]))
    end
  end

  @doc ~S"""
  Generate a polymorphic schema named `:marks`.
  """
  def generate_marks_fields(opts, context) do
    if marks = Keyword.get(opts, :marks, []) do
      marks =
        context
        |> Keyword.get(:marks, [])
        |> Keyword.take(marks)
        |> Enum.map(fn {name, opts} -> {name, opts[:module]} end)

      quote do
        embedded_prosemirror_marks(unquote(marks))
      end
    end
  end
end
