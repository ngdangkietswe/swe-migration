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