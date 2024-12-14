echo "Migrating auth database ..."
mvn flyway:migrate -Dflyway.configFiles=config/local/flyway_auth.conf

echo "Migrating task database ..."
mvn flyway:migrate -Dflyway.configFiles=config/local/flyway_task.conf