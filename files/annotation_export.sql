SELECT
  id AS annotation_id
, regexp_replace(userid, '[^0-9]*', '', 'g') as user_id
, created AS created_on
, updated AS updated_on
, CASE WHEN deleted = TRUE THEN 'TRUE' ELSE 'FALSE' END as is_deleted
, target_selectors -> 0 ->> 'research_identifier' as research_id
, CASE WHEN LENGTH(text) > 1000
    THEN CONCAT(SUBSTRING(text for 1000), '[TRUNCATED]')
    ELSE text
  END as annotated_text
, target_selectors -> 0 ->> 'content' AS highlighted_text
, target_uri AS module_id
FROM annotation;
