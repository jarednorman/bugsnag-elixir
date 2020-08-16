defmodule Bugsnag.HTTPClient do
  @moduledoc """
  A Behavior defining an HTTP Client for Bugsnag
  """
  alias Bugsnag.HTTPClient.Request
  alias Bugsnag.HTTPClient.Response

  @type success :: {:ok, Response.t()}
  @type failure :: {:error, reason :: any()}
  @callback post(Request.t()) :: success() | failure()

  def post(request) do
    request.url
    |> HTTPoison.post(request.body, request.headers, request.opts)
    |> case do
      {:ok, %{body: body, headers: headers, status_code: status}} ->
        {:ok, Response.new(status, headers, body)}

      {:error, %{reason: reason}} ->
        {:error, reason}

      _ ->
        {:error, :unknown}
    end
  end
end
