SELECT contract_id
  , organization_id
  , created_at
  , event_type
FROM {{ ref('prod__contract_events') }}