# Lab - Test App

- App
- Test Rspec
- GraphQL
  - Create Type
  - Resolver
- Sorbet
- Sidekiq
  - Redis
- Temporal

## First init

```bash
bundle install
rails db:migrate
rails s
```

## Temporal

Install Temporal Server: https://learn.temporal.io/getting_started/go/dev_environment/

```bash
brew install temporal
```

Start the Temporal Server

```bash
temporal server start-dev
```

Access the UI: http://localhost:8233/namespaces/ruby-samples/workflows

Start the Temporal Worker

```bash
rake temporal:start_worker
```

Run multiple workflows

```bash
rake scheduler:run_periodic_task
```

Run an workflow

```
curl -X GET 'http://127.0.0.1:3000/temporal?name=test'
```