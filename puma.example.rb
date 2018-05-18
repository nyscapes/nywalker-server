# frozen_string_literal: true
# This file could be duplicated and renamed to puma.rb

# Start|Stop|Restart the app with:
#
# (bundle exec) pumactl -F puma.rb start|stop|restart

# Set the environment appropriately
environment ENV['RACK_ENV'] || 'development'

# Set the pidfile appropriately as well—especially for concurrent instances
# This saves the .pid to the current directory
pidfile "puma.pid"

# Set the port appropriately
bind "tcp://0.0.0.0:9292"

# worker number should be the same number of CPU cores you have
workers Integer(ENV['WEB_CONCURRENCY'] || 2)

threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

rackup "config.ru"

# Where should puma send its logs? Append a ", true" if you want the logs to
# append and not overwrite.
stdout_redirect 'access.log', 'error.log'

daemonize
