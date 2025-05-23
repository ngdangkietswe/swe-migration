migrate-all:
	./script/migrate_local.sh

migrate-auth:
	mvn flyway:migrate -Dflyway.configFiles=config/local/flyway_auth.conf
repair-auth:
	mvn flyway:repair -Dflyway.configFiles=config/local/flyway_auth.conf

migrate-task:
	mvn flyway:migrate -Dflyway.configFiles=config/local/flyway_task.conf
repair-task:
	mvn flyway:repair -Dflyway.configFiles=config/local/flyway_task.conf

migrate-integration:
	mvn flyway:migrate -Dflyway.configFiles=config/local/flyway_integration.conf
repair-integration:
	mvn flyway:repair -Dflyway.configFiles=config/local/flyway_integration.conf

migrate-timetracking:
	mvn flyway:migrate -Dflyway.configFiles=config/local/flyway_timetracking.conf
repair-timetracking:
	mvn flyway:repair -Dflyway.configFiles=config/local/flyway_timetracking.conf

migrate-notification:
	mvn flyway:migrate -Dflyway.configFiles=config/local/flyway_notification.conf
repair-notification:
	mvn flyway:repair -Dflyway.configFiles=config/local/flyway_notification.conf

migrate-workflow:
	mvn flyway:migrate -Dflyway.configFiles=config/local/flyway_workflow.conf
repair-workflow:
	mvn flyway:repair -Dflyway.configFiles=config/local/flyway_workflow.conf