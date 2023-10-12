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
rackup -s falcon -p 9292 config.ru
```

