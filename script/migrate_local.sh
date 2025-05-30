echo "Migrating auth database ..."
mvn flyway:migrate -Dflyway.configFiles=config/local/flyway_auth.conf

echo "Migrating task database ..."
mvn flyway:migrate -Dflyway.configFiles=config/local/flyway_task.conf

echo "Migrating integration database ..."
mvn flyway:migrate -Dflyway.configFiles=config/local/flyway_integration.conf

echo "Migrating timetracking database ..."
mvn flyway:migrate -Dflyway.configFiles=config/local/flyway_timetracking.conf

echo "Migrating notification database ..."
mvn flyway:migrate -Dflyway.configFiles=config/local/flyway_notification.conf

echo "Migrating workflow database..."
mvn flyway:migrate -Dflyway.configFiles=config/local/flyway_workflow.conf