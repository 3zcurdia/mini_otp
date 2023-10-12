# mini_otp

Minimal one time password application

## Requirements

- Ruby 3.2.2
- SQLite

## Setup

Install dependencies

```
bundle install
```

Setup database

```
ruby schema.rb
```

Run the server

```
rackup -s puma -p 9292 config.ru
```

