SELECT distinct contract_id
FROM {{ ref('contract_events') }}