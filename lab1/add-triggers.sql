DROP TABLE IF EXISTS test_table CASCADE;

CREATE TABLE test_table (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    age INTEGER
);

CREATE OR REPLACE FUNCTION test_trigger_func()
RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'Trigger % fired!', TG_NAME;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tr_test_table_name ON test_table;
DROP TRIGGER IF EXISTS tr_test_table_all ON test_table;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM pg_attribute 
        WHERE attrelid = 'test_table'::regclass 
        AND attname = 'name'
    ) THEN
        CREATE TRIGGER tr_test_table_name
        AFTER UPDATE OF name ON test_table
        FOR EACH ROW EXECUTE FUNCTION test_trigger_func();
    ELSE
        RAISE WARNING 'Column "name" does not exist in test_table!';
    END IF;
END
$$;

CREATE TRIGGER tr_test_table_all
AFTER UPDATE ON test_table
FOR EACH ROW EXECUTE FUNCTION test_trigger_func();
