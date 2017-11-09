#!/usr/bin/env bash

# import resources from volume
#cp -f /custom_configurations/custom-config-vol/backend_configs/config/devise.rb /usr/src/app/backend/config/initializers
cp /custom_configurations/custom-config-vol/backend_configs/application.yml /usr/src/app/backend/config/

# Use the "exec" form of CMD so Nginx shuts down gracefully on SIGTERM (i.e. `docker stop`)
rc-service nginx restart

cd backend
bundle exec rails server -b 0.0.0.0