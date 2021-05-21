defmodule Ecto.ExProsemirrorField do
  use Ecto.Type

  def type(), do: :map

  def cast(map) when is_map(map) do
    :error
  end

  def cast(_), do: :error

  def load(data) when is_map(data) do
    :error
  end

  def load(_), do: :error

  def dump(smgth), do: :error
end
