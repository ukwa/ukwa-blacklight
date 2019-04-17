FROM ruby:2.5.3

RUN gem install rails -v 5

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs

WORKDIR /usr/src/app

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN rails db:migrate RAILS_ENV=development
RUN RAILS_ENV=development rake assets:precompile

ENV SOLR_URL=http://solr-server:8983/collection

CMD rails s -b 0.0.0.0
