
dbt_setup_test:
	@dbt debug --profiles-dir .
	@dbt deps --profiles-dir .
	@dbt run --profiles-dir . --full-refresh
	@dbt run --target prod --profiles-dir . --full-refresh
