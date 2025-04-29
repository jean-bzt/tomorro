SELECT
  contract_id
  , organization_id
  , created_at
  , event_type
FROM {{ ref('contract_events') }}

