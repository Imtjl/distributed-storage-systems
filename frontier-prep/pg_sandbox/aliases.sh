#!/bin/bash
# Функции для управления песочницей PostgreSQL

# Запуск песочницы
pg_start() {
    docker-compose up -d
    echo "PostgreSQL sandbox запущен на порту 5432"
}

# Остановка песочницы
pg_stop() {
    docker-compose down
    echo "PostgreSQL sandbox остановлен"
}

# Сброс данных (пересоздание)
pg_reset() {
    docker-compose down
    rm -rf data/*
    docker-compose up -d
    echo "PostgreSQL sandbox сброшен и перезапущен"
}

# Подключение к PostgreSQL
pg_connect() {
    local db=${1:-education}
    local user=${2:-postgres}
    docker exec -it pg_sandbox psql -U "$user" -d "$db"
}

# Запуск скрипта
pg_run() {
    local script=$1
    local db=${2:-education}
    local user=${3:-postgres}
    
    if [ -f "$script" ]; then
        docker exec -i pg_sandbox psql -U "$user" -d "$db" < "$script"
    elif [ -f "scripts/$script" ]; then
        docker exec -i pg_sandbox psql -U "$user" -d "$db" < "scripts/$script"
    else
        echo "Скрипт не найден: $script"
        return 1
    fi
}

# Проверка статуса песочницы
pg_status() {
    if docker ps | grep -q pg_sandbox; then
        echo "PostgreSQL sandbox работает"
        docker exec pg_sandbox pg_isready
    else
        echo "PostgreSQL sandbox остановлен"
    fi
}

# Помощь
pg_help() {
    echo "Команды для управления PostgreSQL песочницей:"
    echo "  pg_start   - Запуск песочницы"
    echo "  pg_stop    - Остановка песочницы"
    echo "  pg_reset   - Полный сброс данных и перезапуск"
    echo "  pg_connect [db] [user] - Подключение к базе данных (по умолчанию: education, postgres)"
    echo "  pg_run script [db] [user] - Запуск SQL-скрипта"
    echo "  pg_status  - Проверка статуса песочницы"
    echo "  pg_help    - Показать эту справку"
}

# Автодополнение команд
_pg_completion() {
    local cur prev scripts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    if [ "$prev" = "pg_run" ]; then
        scripts=$(ls -1 ~/pg_sandbox/scripts/ 2>/dev/null | grep -E "\.sql$")
        COMPREPLY=( $(compgen -W "$scripts" -- "$cur") )
    fi
}

# Регистрация автодополнения
complete -F _pg_completion pg_run
