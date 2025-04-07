select
  column_name as cname
from
  information_schema.columns
where
  table_name = 'groups'
  and table_schema = 'studs'
  and table_catalog = 'education';
