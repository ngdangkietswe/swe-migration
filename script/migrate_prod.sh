echo "Migrating auth database ..."
mvn flyway:migrate -Dflyway.configFiles=config/prod/flyway_auth.conf

echo "Migrating task database ..."
mvn flyway:migrate -Dflyway.configFiles=config/prod/flyway_task.conf
