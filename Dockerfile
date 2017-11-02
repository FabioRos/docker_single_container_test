FROM ruby:2.3-alpine
MAINTAINER Moku srl <support@moku.io>

ENV BUILD_PACKAGES="curl-dev ruby-dev build-base bash git gettext openrc nginx sqlite sqlite-dev" \
    DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev sqlite-dev postgresql-dev mysql-dev" \
    RUBY_PACKAGES="ruby-json yaml nodejs"

# Update and install base packages and nokogiri gem that requires a
# native compilation
RUN apk update && \
    apk upgrade && \
    apk add --update\
    $BUILD_PACKAGES \
    $DEV_PACKAGES \
    $RUBY_PACKAGES && \
    apk add --update --no-cache libstdc++ && \
    apk add --update --no-cache --virtual build-deps build-base make python git bash && \
    gem install libv8 -v 3.16.14.16 && \
    gem install therubyracer && \
    gem install sqlite3-ruby && \
    apk del build-deps && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /usr/src/app



# Copy the app into the working directory. This assumes your Gemfile
# is in the root directory and includes your version of Rails that you
# want to run.
WORKDIR /usr/src/app
COPY . /usr/src/app

EXPOSE 3000
RUN cd generic-api-backend && \
            bundle config build.nokogiri --use-system-libraries && \
            bundle install && \
            bundle clean



# Copy Nginx config template
COPY ./generic-api-backend/config/nginx.conf  /etc/nginx/nginx.conf.orig


RUN adduser -D -u 1000 -g 'www' www && \
        mkdir /www && \
        chown -R www:www /var/lib/nginx && \
        chown -R www:www /www




EXPOSE 80

RUN cd frontend  && \
#    npm install --save-dev @angular/cli@latest && \
    npm install -g @angular/cli@latest && \
    ng build --prod --aot=false




RUN ["chmod", "+x", "/usr/src/app/startup.sh"]
CMD ./startup.sh
