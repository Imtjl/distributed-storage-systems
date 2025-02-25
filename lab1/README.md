# Lab 1 - Mastering PL/pgSQL and PostgreSQL Internals: Finding Triggers

This lab focuses on mastering **PL/pgSQL** (PostgreSQL's procedural language)
and exploring PostgreSQL internals by working with **triggers**. The goal is to
create a script that retrieves information about triggers assigned to a specific
table, using advanced PostgreSQL features like **GUC variables**, **anonymous
blocks**, and **system catalogs**.

## Lab Objectives

The main task is to create an SQL script that:

1. Takes a table name as user input using **GUC variables** and metacommands.
2. Uses an **anonymous PL/pgSQL block** to:
   - Retrieve all triggers assigned to the specified table.
   - Display the triggers and their associated columns in a formatted manner.
3. Handles exceptions, such as missing tables or insufficient privileges.
4. Includes a separate script (`add-triggers.sql`) to:
   - Indelibly create a table (`point_model`) with sample data.
   - Add triggers to the table for testing purposes.

## Files

- [`add-triggers.sql`](./add-triggers.sql): SQL script to create the
  `point_model` table, populate it with data, and add triggers.
- [`find-triggers.sql`](./find-triggers.sql): SQL script to find and display
  triggers assigned to a user-specified table.

## Triggers Created

For testing purposes, the following triggers were created on the `point_model`
table:

1. **`after_update_point_model`**: Executes after an `UPDATE` operation.
2. **`before_insert_point_model`**: Executes before an `INSERT` operation.
3. **`trigger_x`**: Executes after an `UPDATE` on the `x` column.
4. **`trigger_y`**: Executes after an `UPDATE` on the `y` column.

## How to Use

### 1. Add Triggers

Run the `add-triggers.sql` script to create the `point_model` table and add
triggers:

```bash
psql -h your_host -d your_database -v "my_table=s368090.point_model" -f add-triggers.sql
```

### Find triggers

Use the `find-triggers.sql` script to retrieve triggers for a specific table:

```bash
psql -h your_host -d your_database -v "my_table=s368090.your_table" -f find-triggers.sql
```

### Example Output

The `find-triggers.sql` script will display output like this:

```text
COLUMN NAME            TRIGGER NAME
-------------------    ------------------------
ALL                    after_update_point_model
ALL                    before_insert_point_model
x                      trigger_x
y                      trigger_y
```

## Key Learnings

By completing this lab, you will:

- Master PL/pgSQL for writing procedural code in PostgreSQL.

- Understand how to use GUC variables and metacommands for user input.

- Learn to query PostgreSQL system catalogs (e.g., pg_trigger, pg_class) to
  retrieve metadata.

- Handle exceptions and errors gracefully in PL/pgSQL.

- Gain experience in writing idempotent scripts for database operations.
