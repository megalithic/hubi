use Mix.Config

config :logger, :console, format: "$time [$level] $message\n", level: :info
# config :logger, :console, format: "$time $metadata[$level] $message\n", metadata: [:request_id]
