# Hawkr

- [ ] Availability feature
 - [ ] Errors table

# Deploy

1. Build image
2. Push image
3. docker stack deploy hawk -c hawkr/prod.compose.yml --with-registry-auth
