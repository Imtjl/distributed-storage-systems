select column_name as cname
from information_schema.columns
where table_name = 'Groups'
and table_schema = 'studs';
