WITH cte AS (
    SELECT 
        organization_id
        , contract_id
        , created_at
    FROM {{ ref('fact_contracts') }}
    WHERE event_type = 'created'
    AND created_at is not NULL
)

SELECT 
  organization_id
  , COUNT(distinct contract_id) as nb_contracts_created
  , MIN(created_at) as first_contract_created_at
  , MAX(created_at) as last_contract_created_at
FROM cte
GROUP BY 1
ORDER BY 1