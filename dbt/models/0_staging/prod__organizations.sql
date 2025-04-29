SELECT 
  CAST(REGEXP_EXTRACT(organization_id, r'\d+') AS INT64) as organization_id
  , name
  , industry
FROM {{ source('raw', 'organizations') }}
