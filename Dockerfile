FROM ruby:3.2.2

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    git \
    curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /myapp

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . /myapp

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]