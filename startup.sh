#!/usr/bin/env bash

# Use the "exec" form of CMD so Nginx shuts down gracefully on SIGTERM (i.e. `docker stop`)
rc-service nginx restart

cd backend
bundle exec rails server -b 0.0.0.0