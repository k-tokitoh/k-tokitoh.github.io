# See https://pages.github.com/versions/
FROM ruby:2.7.3

WORKDIR "/srv/jekyll"

COPY ./docs/Gemfile ./docs/Gemfile.lock ./

RUN bundle install

EXPOSE 4000

CMD bundle exec jekyll serve --host 0.0.0.0
