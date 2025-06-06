# Подготовка к рубежной работе по PostgreSQL

## Содержимое репозитория

- **theory.md** - теоретический материал для подготовки к рубежной работе,
  включающий:

  - Архитектуру PostgreSQL
  - Транзакции и WAL
  - Роли и привилегии
  - Системный каталог
  - Разбор варианта прошлогодней рубежной работы

- **pg_sandbox/** - песочница PostgreSQL для практики

## Использование песочницы PostgreSQL

> [!IMPORTANT]  
> Для работы песочницы требуется установленный `Docker` и `Docker Compose`.

```bash
cd pg_sandbox

# Инициализация функций
source aliases.fish  # для Fish shell
# или
source aliases.sh    # для Bash shell

# Запуск песочницы
pg_start

# Подключение к базе данных
pg_connect edu
# или просто (edu используется по умолчанию)
pg_connect

# Запуск тестового скрипта
pg_run role_task.sql

# Остановка песочницы
pg_stop

# Полный сброс данных
pg_reset
```
