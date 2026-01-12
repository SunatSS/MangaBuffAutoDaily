#!/bin/bash

# MangaBuffAutoDaily - macOS Build and Run Script
# Этот скрипт автоматизирует процесс сборки и запуска приложения на macOS

set -e  # Остановка при ошибке

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функция для вывода сообщений
print_message() {
    echo -e "${GREEN}[MangaBuff]${NC} $1"
}

print_error() {
    echo -e "${RED}[ОШИБКА]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[ВНИМАНИЕ]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[ИНФО]${NC} $1"
}

# Проверка операционной системы
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "Этот скрипт предназначен только для macOS!"
    exit 1
fi

print_message "Начало сборки MangaBuffAutoDaily для macOS..."
echo ""

# Проверка наличия Java
print_info "Проверка Java..."
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d. -f1)
    print_message "Java найдена: версия $JAVA_VERSION"
    
    if [ "$JAVA_VERSION" -lt 17 ]; then
        print_error "Требуется Java 17 или выше. Установлена версия: $JAVA_VERSION"
        print_info "Установите Java через: brew install openjdk@21"
        exit 1
    fi
else
    print_error "Java не найдена!"
    print_info "Установите Java через: brew install openjdk@21"
    exit 1
fi

# Проверка наличия Maven
print_info "Проверка Maven..."
if [ -f "./mvnw" ]; then
    print_message "Используется Maven Wrapper"
    MVN_CMD="./mvnw"
    chmod +x ./mvnw
elif command -v mvn &> /dev/null; then
    print_message "Используется системный Maven"
    MVN_CMD="mvn"
else
    print_error "Maven не найден!"
    print_info "Установите Maven через: brew install maven"
    exit 1
fi

# Проверка наличия Google Chrome
print_info "Проверка Google Chrome..."
if [ -d "/Applications/Google Chrome.app" ]; then
    print_message "Google Chrome найден"
else
    print_warning "Google Chrome не найден!"
    print_info "Установите через: brew install --cask google-chrome"
    print_info "Приложение может работать некорректно без Chrome"
fi

echo ""
print_message "Все проверки пройдены! Начинаем сборку..."
echo ""

# Очистка предыдущей сборки
print_info "Очистка предыдущих сборок..."
$MVN_CMD clean

# Сборка проекта с профилем macOS
print_info "Сборка проекта (это может занять несколько минут)..."
if $MVN_CMD package -P mac -DskipTests; then
    echo ""
    print_message "✅ Сборка успешно завершена!"
    
    JAR_FILE="target/mangaBuffJob-0.0.1-SNAPSHOT.jar"
    
    if [ -f "$JAR_FILE" ]; then
        JAR_SIZE=$(du -h "$JAR_FILE" | cut -f1)
        print_info "Размер JAR файла: $JAR_SIZE"
        print_info "Путь: $JAR_FILE"
        
        echo ""
        read -p "Запустить приложение сейчас? (y/n): " -n 1 -r
        echo ""
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_message "Запуск приложения..."
            java -Xmx2G -Dfile.encoding=UTF-8 -jar "$JAR_FILE"
        else
            echo ""
            print_message "Для запуска приложения используйте команду:"
            echo "  java -jar $JAR_FILE"
            echo ""
            print_info "Или с увеличенной памятью:"
            echo "  java -Xmx2G -jar $JAR_FILE"
        fi
    else
        print_error "JAR файл не найден после сборки!"
        exit 1
    fi
else
    echo ""
    print_error "Ошибка при сборке проекта!"
    print_info "Проверьте логи выше для получения подробностей"
    exit 1
fi
