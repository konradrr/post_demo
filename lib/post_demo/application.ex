defmodule PostDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PostDemoWeb.Telemetry,
      PostDemo.Repo,
      {DNSCluster, query: Application.get_env(:post_demo, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PostDemo.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PostDemo.Finch},
      # Start a worker by calling: PostDemo.Worker.start_link(arg)
      # {PostDemo.Worker, arg},
      # Start to serve requests, typically the last entry
      PostDemoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PostDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PostDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
