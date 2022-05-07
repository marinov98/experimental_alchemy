defmodule ProjectManagerWeb.DocumentView do
  use ProjectManagerWeb, :view
  use JaSerializer.PhoenixView

  attributes([:title, :description])
end
