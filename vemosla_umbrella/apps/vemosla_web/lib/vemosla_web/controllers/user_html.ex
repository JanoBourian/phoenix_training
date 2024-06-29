defmodule VemoslaWeb.UserHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use VemoslaWeb, :html

  embed_templates "user_html/*"
end
