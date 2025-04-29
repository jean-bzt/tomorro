# Tomorro Technical test

## Stack
- Cloud Provider: GCP multi env architecture
    - handled by terraform
- datawarehouse: Biquery
- data loading: simple python notebook
    - Airbyte would be used in production
- data transfo: dbt


## Technical scope repository
The focus has been made on data modeling / transformation and test:  
- dbt folder with main SQL transfomations 
- data lineage and documentation
- simple notebook to load data into dev and prod ingestion projects
- design of lineage for wider data sources and data modeling
- design of repository for future CICD

## To go further
- add CI
- add CD
- integrate dbt into data mono-repo
- add servelress ELT orchestration
- add docker images for orchestration 