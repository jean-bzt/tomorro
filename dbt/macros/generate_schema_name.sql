{% macro generate_schema_name(custom_schema_name=none, node=none) -%}
    {{- log("Start generate_schema_name macro") -}}
    {{- log("Initial default_schema : " ~ target.schema) -}}
    {{- log("Initial default_database : " ~ target.database) -}}
    {{- log("node.fqn : " ~ node.fqn) -}}

    {%- set default_schema = target.schema -%}
    {%- set common_schema = ['monitoring', 'monitoring_src', 'monitoring_stg'] -%}

    {%- if custom_schema_name is not none -%}
        {%- if target.name in ['local', 'cicd'] and custom_schema_name.strip() not in common_schema-%}
            {%- set final_schema = var('user_id') ~ '_' ~ custom_schema_name.strip() -%}
            {{- log("final_schema : " ~ final_schema) -}}
        	{{ final_schema }}
        {%- else -%}
            {%- set final_schema = custom_schema_name.strip() -%}
        	{{ final_schema }}
        {%- endif -%}

    {%- else -%}
        {%- if node.fqn|length >=3 -%}
            {%- set dbt_layer = node.fqn[1] -%}
            {{- log("DBT layer : " ~ dbt_layer) -}}
            {%- if target.name in ['local', 'cicd'] and dbt_layer not in common_schema-%}
                {%- set final_schema = var('user_id') ~ '_' ~ dbt_layer -%}
        	    {{ final_schema }}
            {%- else -%}
                {%- set final_schema = dbt_layer -%}
        	    {{ final_schema }}
            {%- endif -%}
        {%- else -%}
            {%- set final_schema = dbt_layer -%}
            {{ final_schema }}
        {%- endif -%}

    {%- endif -%}

    {{- log("Will write in : " ~ target.database ~ '.' ~ final_schema) -}}

{%- endmacro %}



{% macro generate_schema_name_last_draft(custom_schema_name=none, node=none) -%}
    {{- log("Start generate_schema_name macro") -}}
    {{- log("Initial default_schema : " ~ target.schema) -}}
    {{- log("Initial default_database : " ~ target.database) -}}
    {{- log("node.fqn : " ~ node.fqn) -}}

    {%- set default_schema = target.schema -%}
    {%- set common_schema = ['monitoring', 'monitoring_src', 'monitoring_stg'] -%}

    {%- if custom_schema_name is not none -%}
        {%- if target.name in ['local', 'cicd'] and custom_schema_name not in common_schema-%}
        	{{ var('user_id') }}_{{ custom_schema_name | trim }}
        {%- else -%}
        	{{ custom_schema_name | trim }}
        {%- endif -%}

    {%- else -%}
        {%- if node.fqn|length >=3 -%}
            {%- set dbt_layer = node.fqn[1] -%}
            {{- log("DBT layer : " ~ dbt_layer) -}}
            {%- if target.name in ['local', 'cicd'] and automatic_schema not in common_schema-%}
        	    {{ var('user_id') }}_{{ dbt_layer }}
            {%- else -%}
        	    {{ dbt_layer }}
            {%- endif -%}
        {%- else -%}
            {{ dbt_layer }}
        {%- endif -%}

    {%- endif -%}

    

{%- endmacro %}
