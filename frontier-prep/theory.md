# Подготовка к рубежной работе по РСХД

## Архитектура PostgreSQL

### ANSI-SPARC

### Компоненты СУБД

#### Процессы СУБД

- postmaster
- postgres
- background writer
- checkpointer
- WAL writer
- archiver
- stats collector

#### Память PostgreSQL

- Shared buffers
- WAL buffers
- CLOG buffers
- Lock space

### WAL

#### Принцип работы

#### LSN (Log Sequence Number)

#### Контрольные точки (checkpoints)

#### Восстановление после сбоев

### Файловая структура

#### PGDATA

#### Структура директорий

#### Табличные пространства

## Кластер, БД, Схема, Таблица

### Иерархия объектов

- кластер бд
- бд
- схема
- таблица

### Табличные пространства

### Конфигурация

- postgresql.conf
- pg_hba.conf
- Динамические параметры

### Конфигурационные утилиты (управление сервером)

- pg_ctl
- pg_reload_conf()

## Системный каталог и метаданные

### Системные таблицы

- pg_class
- pg_attribute
- pg_database
- pg_roles

### Information schema

- стандартный интерфейс к метаданным
- отличие от системных каталогов

### OID, filenode

- как находить объекты по OID
- связь OID и фс

## Транзакции

### ACID

### Виды

### Идентификация транзакций (xid)

### MVCC (SSI)

### Уровни изоляции

1. Read Uncommiteted (не поддерживается psql)
2. Read Committed
3. Repeatable Read
4. Serializable

### VACUUM

- Принцип работы
- VACUUM vs VACUUM FULL
- avtovacuum

## Роли и привилегии

### Управление пользователями

### Группы ролей

### Объектные привилегии

## Практика SQL

### Создание/изменение объектов

### Управление привилегиями

### Запросы к системному каталогу

# Разбор прошлогоднего варианта

1. Setup THE EXACT evironment presented here:

| ![img](../docs/old-frontier.jpg) |
| -------------------------------- |

2. Run sql scripts, check behaviour, play around, research, memorize sql.
