SELECT 
  organization_id
  , name
  , industry
FROM {{ ref('prod__organizations') }}