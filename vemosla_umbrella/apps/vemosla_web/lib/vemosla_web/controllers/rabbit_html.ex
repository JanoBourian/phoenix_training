defmodule VemoslaWeb.RabbitHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use VemoslaWeb, :html

  embed_templates "rabbit_html/*"
end
