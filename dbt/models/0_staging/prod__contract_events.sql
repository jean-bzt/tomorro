SELECT 
  CAST(REGEXP_EXTRACT(contract_id, r'\d+') AS INT64) as contract_id
  , CAST(REGEXP_EXTRACT(COALESCE(organization_id, organizationId), r'\d+') AS INT64) as organization_id
  , {{ format_datetime("COALESCE(created_at, createdAt)") }} as created_at
  , event_type

FROM {{ source('raw', 'contract_events') }}
