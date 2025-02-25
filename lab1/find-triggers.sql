\if :{?my_table}
    SET "my.table" TO :'my_table';
\else
    \echo "ERROR: Set 'my_table' variable. Example: psql -v my_table=schema.table"
    \quit
\endif

DO $$
DECLARE
    in_table     TEXT := current_setting('my.table');
    input_schema TEXT;
    input_table  TEXT;
    rec          RECORD;
    v_attnum     SMALLINT;
    v_attname    TEXT;
    output_text  TEXT;
    col_array    SMALLINT[];
BEGIN
    IF position('.' IN in_table) > 0 THEN
        input_schema := split_part(in_table, '.', 1);
        input_table  := split_part(in_table, '.', 2);
    ELSE
        input_schema := current_schema();
        input_table  := in_table;
    END IF;

    PERFORM 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE n.nspname = input_schema
      AND c.relname = input_table
      AND c.relkind = 'r';

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Table "%" not found!', in_table;
    END IF;

    RAISE NOTICE 'COLUMN NAME            TRIGGER NAME';
    RAISE NOTICE '-------------------    ------------------------';

    FOR rec IN
        SELECT 
            t.tgname,
            t.tgattr,
            c.oid AS table_oid,
            c.relname AS table_name
        FROM pg_trigger t
        JOIN pg_class c ON t.tgrelid = c.oid
        JOIN pg_namespace n ON c.relnamespace = n.oid
        WHERE 
            n.nspname = input_schema
            AND c.relname = input_table
            AND NOT t.tgisinternal
    LOOP
        col_array := (
            SELECT array_agg(attnum::SMALLINT)
            FROM unnest(rec.tgattr::int2[]) AS attnum
            WHERE attnum IS NOT NULL
        );

        IF col_array IS NOT NULL AND array_length(col_array, 1) > 0 THEN
            FOREACH v_attnum IN ARRAY col_array
            LOOP
                SELECT attname INTO v_attname
                FROM pg_attribute
                WHERE 
                    attrelid = rec.table_oid
                    AND attnum = v_attnum;

                IF FOUND THEN
                    output_text := v_attname || repeat(' ', 20 - length(v_attname)) || rec.tgname;
                    RAISE NOTICE '%', output_text;
                ELSE
                    RAISE WARNING 'Column % not found in table %', v_attnum, rec.table_name;
                END IF;
            END LOOP;
        ELSE
            output_text := 'ALL' || repeat(' ', 20) || rec.tgname;
            RAISE NOTICE '%', output_text;
        END IF;
    END LOOP;

EXCEPTION
    WHEN SQLSTATE '42501' THEN
        RAISE NOTICE 'Insufficient privileges to read system catalogs or table.';
    WHEN SQLSTATE '42P01' THEN
        RAISE NOTICE 'Table does not exist (SQLSTATE 42P01).';
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error: %', SQLERRM;
END
$$ LANGUAGE plpgsql;
