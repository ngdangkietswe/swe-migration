migrate-all:
	./script/migrate_local.sh

migrate-auth:
	mvn flyway:migrate -Dflyway.configFiles=config/local/flyway_auth.conf

migrate-task:
	mvn flyway:migrate -Dflyway.configFiles=config/local/flyway_task.conf