{%- macro format_datetime(input_string=none) -%}
  CASE
    -- ISO format: YYYY-MM-DD HH:MM:SS
    WHEN REGEXP_CONTAINS({{ input_string }}, r'^\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}(|\.\d+)(Z|[+-]\d{2}:?\d{2})?$') THEN 
      FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', 
        SAFE.PARSE_DATETIME('%Y-%m-%d %H:%M:%S', REGEXP_REPLACE({{ input_string }}, r'T|Z|[+-]\d{2}:?\d{2}|\.\d+', ' ')))
      
    -- ISO format with fractional seconds
    WHEN REGEXP_CONTAINS({{ input_string }}, r'^\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}\.\d{1,6}(Z|[+-]\d{2}:?\d{2})?$') THEN
      FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', 
        SAFE.PARSE_DATETIME('%Y-%m-%d %H:%M:%E6S', REGEXP_REPLACE({{ input_string }}, r'T|Z|[+-]\d{2}:?\d{2}', ' ')))
      
    -- MM/DD/YYYY HH:MM:SS or DD/MM/YYYY HH:MM:SS with optional AM/PM
    WHEN REGEXP_CONTAINS({{ input_string }}, r'^\d{1,2}/\d{1,2}/\d{4} \d{1,2}:\d{2}:\d{2}(|\.\d+)( AM| PM)?$') THEN
      CASE
        -- Try MM/DD/YYYY format first (US)
        WHEN SAFE.PARSE_DATETIME('%m/%d/%Y %H:%M:%S', REGEXP_REPLACE({{ input_string }}, r' AM| PM|\.\d+', '')) IS NOT NULL THEN
          FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', 
            SAFE.PARSE_DATETIME('%m/%d/%Y %H:%M:%S', REGEXP_REPLACE({{ input_string }}, r' AM| PM|\.\d+', '')))
        -- Then try DD/MM/YYYY format (European)
        WHEN SAFE.PARSE_DATETIME('%d/%m/%Y %H:%M:%S', REGEXP_REPLACE({{ input_string }}, r' AM| PM|\.\d+', '')) IS NOT NULL THEN
          FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', 
            SAFE.PARSE_DATETIME('%d/%m/%Y %H:%M:%S', REGEXP_REPLACE({{ input_string }}, r' AM| PM|\.\d+', '')))
        -- Try 12-hour format with AM/PM
        WHEN REGEXP_CONTAINS({{ input_string }}, r' [AP]M$') AND 
             SAFE.PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', {{ input_string }}) IS NOT NULL THEN
          FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', SAFE.PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', {{ input_string }}))
        WHEN REGEXP_CONTAINS({{ input_string }}, r' [AP]M$') AND 
             SAFE.PARSE_DATETIME('%d/%m/%Y %I:%M:%S %p', {{ input_string }}) IS NOT NULL THEN
          FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', SAFE.PARSE_DATETIME('%d/%m/%Y %I:%M:%S %p', {{ input_string }}))
        ELSE NULL
      END
      
    -- MM-DD-YYYY or DD-MM-YYYY with optional AM/PM
    WHEN REGEXP_CONTAINS({{ input_string }}, r'^\d{1,2}-\d{1,2}-\d{4} \d{1,2}:\d{2}:\d{2}(|\.\d+)( AM| PM)?$') THEN
      CASE
        -- Try MM-DD-YYYY format first
        WHEN SAFE.PARSE_DATETIME('%m-%d-%Y %H:%M:%S', REGEXP_REPLACE({{ input_string }}, r' AM| PM|\.\d+', '')) IS NOT NULL THEN
          FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', 
            SAFE.PARSE_DATETIME('%m-%d-%Y %H:%M:%S', REGEXP_REPLACE({{ input_string }}, r' AM| PM|\.\d+', '')))
        -- Then try DD-MM-YYYY format
        WHEN SAFE.PARSE_DATETIME('%d-%m-%Y %H:%M:%S', REGEXP_REPLACE({{ input_string }}, r' AM| PM|\.\d+', '')) IS NOT NULL THEN
          FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', 
            SAFE.PARSE_DATETIME('%d-%m-%Y %H:%M:%S', REGEXP_REPLACE({{ input_string }}, r' AM| PM|\.\d+', '')))
        -- Try 12-hour format with AM/PM
        WHEN REGEXP_CONTAINS({{ input_string }}, r' [AP]M$') AND 
             SAFE.PARSE_DATETIME('%m-%d-%Y %I:%M:%S %p', {{ input_string }}) IS NOT NULL THEN
          FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', SAFE.PARSE_DATETIME('%m-%d-%Y %I:%M:%S %p', {{ input_string }}))
        WHEN REGEXP_CONTAINS({{ input_string }}, r' [AP]M$') AND 
             SAFE.PARSE_DATETIME('%d-%m-%Y %I:%M:%S %p', {{ input_string }}) IS NOT NULL THEN
          FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', SAFE.PARSE_DATETIME('%d-%m-%Y %I:%M:%S %p', {{ input_string }}))
        ELSE NULL
      END
      
    -- YYYY/MM/DD HH:MM:SS
    WHEN REGEXP_CONTAINS({{ input_string }}, r'^\d{4}/\d{1,2}/\d{1,2} \d{1,2}:\d{2}:\d{2}(|\.\d+)( AM| PM)?$') THEN
      CASE
        WHEN REGEXP_CONTAINS({{ input_string }}, r' [AP]M$') THEN 
          FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', SAFE.PARSE_DATETIME('%Y/%m/%d %I:%M:%S %p', {{ input_string }}))
        ELSE 
          FORMAT_DATETIME('%Y-%m-%d %H:%M:%S',
            SAFE.PARSE_DATETIME('%Y/%m/%d %H:%M:%S', REGEXP_REPLACE({{ input_string }}, r'\.\d+', '')))
      END
      
    -- DD.MM.YYYY HH:MM:SS (European format with dots)
    WHEN REGEXP_CONTAINS({{ input_string }}, r'^\d{1,2}\.\d{1,2}\.\d{4} \d{1,2}:\d{2}:\d{2}(|\.\d+)( AM| PM)?$') THEN
      CASE
        WHEN REGEXP_CONTAINS({{ input_string }}, r' [AP]M$') THEN 
          FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', SAFE.PARSE_DATETIME('%d.%m.%Y %I:%M:%S %p', {{ input_string }}))
        ELSE 
          FORMAT_DATETIME('%Y-%m-%d %H:%M:%S',
            SAFE.PARSE_DATETIME('%d.%m.%Y %H:%M:%S', REGEXP_REPLACE({{ input_string }}, r'\.\d+', '')))
      END
      
    -- YYYYMMDD_HHMMSS
    WHEN REGEXP_CONTAINS({{ input_string }}, r'^\d{8}_\d{6}$') THEN
      FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', SAFE.PARSE_DATETIME('%Y%m%d_%H%M%S', {{ input_string }}))
      
    -- YYYY-MM-DD (date only)
    WHEN REGEXP_CONTAINS({{input_string}}, r'^\d{4}-\d{2}-\d{2}$') THEN
      FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', SAFE.PARSE_DATETIME('%Y-%m-%d', {{ input_string }}))
      
    -- MM/DD/YYYY or DD/MM/YYYY (date only)
    WHEN REGEXP_CONTAINS({{ input_string }}, r'^\d{1,2}/\d{1,2}/\d{4}$') THEN
      CASE
        -- Try MM/DD/YYYY format first (US)
        WHEN SAFE.PARSE_DATETIME('%m/%d/%Y', {{ input_string }}) IS NOT NULL THEN
          FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', SAFE.PARSE_DATETIME('%m/%d/%Y', {{ input_string }}))
        -- Then try DD/MM/YYYY format (European)
        WHEN SAFE.PARSE_DATETIME('%d/%m/%Y', {{ input_string }}) IS NOT NULL THEN
          FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', SAFE.PARSE_DATETIME('%d/%m/%Y', {{ input_string }}))
        ELSE NULL
      END
      
    -- YYYY/MM/DD (date only)
    WHEN REGEXP_CONTAINS({{ input_string }}, r'^\d{4}/\d{1,2}/\d{1,2}$') THEN
      FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', SAFE.PARSE_DATETIME('%Y/%m/%d', {{ input_string }}))
      
    -- DD.MM.YYYY (date only)
    WHEN REGEXP_CONTAINS({{ input_string }}, r'^\d{1,2}\.\d{1,2}\.\d{4}$') THEN
      FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', SAFE.PARSE_DATETIME('%d.%m.%Y', {{ input_string }}))
      
    -- YYYYMMDD (date only)
    WHEN REGEXP_CONTAINS({{ input_string }}, r'^\d{8}$') THEN
      FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', SAFE.PARSE_DATETIME('%Y%m%d', {{ input_string }}))
      
    -- Month DD, YYYY
    WHEN REGEXP_CONTAINS({{ input_string }}, r'^[A-Za-z]+ \d{1,2}, \d{4}$') THEN
      FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', SAFE.PARSE_DATETIME('%B %d, %Y', {{ input_string }}))
      
    -- DD Month YYYY
    WHEN REGEXP_CONTAINS({{ input_string }}, r'^\d{1,2} [A-Za-z]+ \d{4}$') THEN
      FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', SAFE.PARSE_DATETIME('%d %B %Y', {{ input_string }}))
      
    -- RFC 822 format: Tue, 03 Jun 2008 11:05:30 GMT
    WHEN REGEXP_CONTAINS({{ input_string }}, r'^[A-Za-z]{3}, \d{2} [A-Za-z]{3} \d{4} \d{2}:\d{2}:\d{2}') THEN
      FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', 
        SAFE.PARSE_DATETIME('%a, %d %b %Y %H:%M:%S', REGEXP_REPLACE({{ input_string }}, r' GMT| [+-]\d{4}$', '')))
      
    -- Unix timestamp (seconds since epoch)
    WHEN REGEXP_CONTAINS({{ input_string }}, r'^\d{10}$') THEN
      FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', TIMESTAMP_SECONDS(CAST({{ input_string }} AS INT64)))
      
    -- Unix timestamp milliseconds
    WHEN REGEXP_CONTAINS({{ input_string }}, r'^\d{13}$') THEN
      FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', TIMESTAMP_MILLIS(CAST({{ input_string }} AS INT64)))
      
    -- HH:MM:SS (time only - will use current date)
    WHEN REGEXP_CONTAINS({{ input_string }}, r'^\d{1,2}:\d{2}:\d{2}(|\.\d+)( AM| PM)?$') THEN
      FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', DATETIME(CURRENT_DATE(), 
        CASE
          WHEN REGEXP_CONTAINS({{ input_string }}, r' [AP]M$') THEN TIME(PARSE_TIME('%I:%M:%S %p', {{ input_string }}))
          ELSE TIME(PARSE_TIME('%H:%M:%S', {{ input_string }}))
        END))
        
    ELSE NULL
  END
{%- endmacro -%}
