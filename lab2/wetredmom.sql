-- Simple table, without specifying the table space
-- Will be created in pg_default
CREATE TABLE test_data (id SERIAL PRIMARY KEY, name TEXT, value INTEGER);

-- Fill the table with some sample data
INSERT INTO
  test_data (name, value)
VALUES
  ('test1', 100),
  ('test2', 200),
  ('test3', 300);

-- Index in special sutom table space called `index_space`
CREATE INDEX idx_test_data_name ON test_data (name) TABLESPACE index_space;
