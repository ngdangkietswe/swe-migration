echo "Migrating auth database ..."
mvn flyway:migrate -Dflyway.configFiles=config/prod/flyway_auth.conf