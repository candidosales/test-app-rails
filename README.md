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


## Temporal

Install Temporal Server: https://learn.temporal.io/getting_started/go/dev_environment/

```bash
brew install temporal
```

Start the Temporal Server

```bash
temporal-server start
```

Access the UI: http://localhost:8233/namespaces/ruby-samples/workflows

Start the Temporal Worker

```bash
rake temporal:start_worker
```