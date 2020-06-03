Price checker from various crypto exchanges. Used for a failed crypto exchange. Not maintained. For archived purposes.

# Hawkr

- [ ] Availability feature
 - [ ] Errors table

# Deploy

1. Build image
2. Push image
3. docker stack deploy hawk -c hawkr/prod.compose.yml --with-registry-auth

# Upgrading timescaledb

- go to psql and run command below
- alter extension timescaledb update

```
# example
docker exec -it dc68d97529d5 psql -U postgres -t hawkr_db
psql (10.3)
Type "help" for help.
hawkr_db=# alter extension timescaledb update;
```
