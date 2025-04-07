select table_name as tname
from information_schema.tables
where table_schema = 'PUBLIC'
and table_type = 'BASE TABLE';
