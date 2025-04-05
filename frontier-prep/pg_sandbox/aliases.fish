#!/usr/bin/env fish
# Функции для управления песочницей PostgreSQL

# Запуск песочницы
function pg_start
    docker-compose up -d
    echo "PostgreSQL sandbox запущен на порту 6789"
end

# Остановка песочницы
function pg_stop
    docker-compose down
    echo "PostgreSQL sandbox остановлен"
end

# Сброс данных (пересоздание)
function pg_reset
    docker-compose down
    rm -rf data/*
    docker-compose up -d
    echo "PostgreSQL sandbox сброшен и перезапущен"
end

# Подключение к PostgreSQL
function pg_connect
    set db $argv[1]
    set user $argv[2]
    
    # Значения по умолчанию
    if test -z "$db"
        set db "education"
    end
    
    if test -z "$user"
        set user "postgres"
    end
    
    docker exec -it pg_sandbox psql -U "$user" -d "$db"
end

# Запуск скрипта
function pg_run
    set script $argv[1]
    set db $argv[2]
    set user $argv[3]
    
    # Значения по умолчанию
    if test -z "$db"
        set db "education"
    end
    
    if test -z "$user"
        set user "postgres"
    end
    
    if test -e "$script"
        docker exec -i pg_sandbox psql -U "$user" -d "$db" < "$script"
    else if test -e "scripts/$script"
        docker exec -i pg_sandbox psql -U "$user" -d "$db" < "scripts/$script"
    else
        echo "Скрипт не найден: $script"
        return 1
    end
end

# Проверка статуса песочницы
function pg_status
    if docker ps | grep -q pg_sandbox
        echo "PostgreSQL sandbox работает"
        docker exec pg_sandbox pg_isready
    else
        echo "PostgreSQL sandbox остановлен"
    end
end

# Помощь
function pg_help
    echo "Команды для управления PostgreSQL песочницей:"
    echo "  pg_start   - Запуск песочницы"
    echo "  pg_stop    - Остановка песочницы"
    echo "  pg_reset   - Полный сброс данных и перезапуск"
    echo "  pg_connect [db] [user] - Подключение к базе данных (по умолчанию: education, postgres)"
    echo "  pg_run script [db] [user] - Запуск SQL-скрипта"
    echo "  pg_status  - Проверка статуса песочницы"
    echo "  pg_help    - Показать эту справку"
end
