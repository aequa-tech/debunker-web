FROM ruby:3.1.4
WORKDIR /debunker-web

RUN apt-get update && apt-get install -y \
    build-essential \
    postgresql-client \
    nodejs \
    npm

RUN npm install --global yarn

ENV DOCKERIZED true

COPY . .
RUN bundle config --global frozen 1 && bundle install
RUN yarn install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
