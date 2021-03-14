defmodule GoodreadsLibrary.ErrorTracker do
  require Logger

  def capture_message(message, opts) do
    Logger.warn("#{inspect(message)}: #{inspect(opts)}")
  end
end
