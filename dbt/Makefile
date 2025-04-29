
dbt_setup_test:
	@dbt debug --profiles-dir .
	@dbt deps --profiles-dir .
	@dbt run --profiles-dir . --full-refresh

dbt_run_dev:
	@dbt run --profiles-dir . -t dev --full-refresh

dbt_run_prod:
	@dbt run --profiles-dir . -t prod --full-refresh

dbt_docs:
	@dbt docs generate --profiles-dir . --target prod
	@dbt docs serve --profiles-dir .