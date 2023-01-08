# Spackle Ruby Library

[![CI](https://github.com/spackleso/spackle-ruby/actions/workflows/test.yml/badge.svg)](https://github.com/spackleso/spackle-ruby/actions/workflows/test.yml)

The Spackle Python library provides optimized access to billing aware flags created on the Spackle platform.

## Documentation

See the [Python API docs](https://docs.spackle.so/python).

## Setup

### Install the Spackle library

```sh
gem install spackle-ruby
```

### Bundler
source 'https://rubygems.org'

```ruby
gem 'spackle'
```

### Configure your environment
In order to use Spackle, you need to configure your API key on the `Spackle` module. You can find your API key in Spackle app [settings page](https://dashboard.stripe.com/settings/apps/so.spackle.stripe).

```ruby
require 'spackle'

Spackle.api_key = "<api key>"
```

### Bootstrap the client (optional)

The Spackle client requires a single initialization step that includes a network request. To front load this process, you can call the `bootstrap` method in your codebase.

```ruby
Spackle.bootstrap()
```

## Usage

### Fetch a customer

Spackle uses stripe ids as references to customer features.

```ruby
customer = Spackle::Customer.retrieve("cus_00000000")
```

### Verify feature access

```ruby
customer.enabled("feature_key")
```

### Fetch a feature limit

```ruby
customer.limit("feature_key")
```

## Logging
The Spackle Python library emits logs as it performs various internal tasks. You can control the verbosity of Spackle's logging a few different ways:

1. Set the environment variable SPACKLE_LOG to the value `debug`, `info`, or `error`

   ```sh
   $ export SPACKLE_LOG=debug
   ```

2. Set Spackle.log_level:

   ```ruby
   Spackle.log_level = 'debug'
   ```
