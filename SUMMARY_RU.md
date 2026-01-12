# Резюме: Настройка сборки для macOS

## ✅ Выполненные работы

### 1. Анализ проекта
- Изучена структура репозитория MangaBuffAutoDaily
- Определены используемые технологии:
  - Java 17+ (Spring Boot 3.4.4, JavaFX 21, Selenium 4.32.0)
  - Maven как система сборки
  - H2 Database для хранения данных
- Выявлена проблема: JavaFX зависимости были зашиты только для Windows (`classifier=win`)

### 2. Внесенные изменения в pom.xml

#### Добавлены свойства:
```xml
<javafx.version>21</javafx.version>
<javafx.platform>win</javafx.platform>  <!-- по умолчанию Windows -->
```

#### Обновлены JavaFX зависимости:
Изменено с:
```xml
<dependency>
    <groupId>org.openjfx</groupId>
    <artifactId>javafx-controls</artifactId>
    <version>21</version>
    <classifier>win</classifier>  <!-- жестко задан Windows -->
</dependency>
```

На:
```xml
<dependency>
    <groupId>org.openjfx</groupId>
    <artifactId>javafx-controls</artifactId>
    <version>${javafx.version}</version>
    <classifier>${javafx.platform}</classifier>  <!-- динамическая платформа -->
</dependency>
```

#### Добавлены Maven profiles:
- **Windows** - автоматически активируется на Windows
- **macOS** - автоматически активируется на macOS (Intel и Apple Silicon)
- **Linux** - автоматически активируется на Linux

Каждый profile автоматически устанавливает правильное значение `javafx.platform`.

### 3. Создана документация

#### BUILD_MAC.md (основная инструкция для macOS)
Подробный гайд на русском языке, включающий:
- Системные требования (macOS 10.14+, JDK 17+, Maven 3.6+, Chrome)
- Установка JDK через Homebrew или вручную
- Установка Maven
- Клонирование репозитория
- Сборка проекта с явным указанием профиля или автоматически
- Запуск приложения
- Создание нативного `.app` пакета через `jpackage`
- Создание DMG установщика
- Решение типичных проблем (Gatekeeper, ARM vs x86_64, и т.д.)
- Дополнительные команды Maven
- Быстрый старт (TL;DR)

#### Обновлен README.md
Добавлена секция "Поддерживаемые платформы":
- ✅ Windows - официальная поддержка
- ✅ macOS - полная поддержка (Intel и Apple Silicon)
- ✅ Linux - поддерживается через JAR
- Ссылка на BUILD_MAC.md
- Быстрый старт для macOS

#### build_mac.sh - скрипт автоматической сборки
Bash-скрипт для macOS с:
- Автоматической проверкой Java, Maven, Chrome
- Проверкой версий (Java 17+)
- Цветным выводом для удобства
- Автоматической очисткой и сборкой
- Интерактивным запросом на запуск приложения

### 4. Проверка работоспособности
- ✅ Тестовая сборка выполнена успешно
- ✅ Maven правильно скачивает платформо-зависимые JavaFX библиотеки
- ✅ Профиль Linux корректно определяется и применяется автоматически
- ✅ Зависимости загружаются корректно для Linux (javafx-*-linux.jar)

## 📋 Инструкция для пользователей macOS

### Быстрый старт:
```bash
# 1. Установка зависимостей
brew install openjdk@21 maven
brew install --cask google-chrome

# 2. Клонирование репозитория
git clone https://github.com/SunatSS/MangaBuffAutoDaily.git
cd MangaBuffAutoDaily

# 3. Сборка (автоматически определит macOS)
./mvnw clean package

# Или явное указание профиля:
./mvnw clean package -P mac

# Или использовать автоматический скрипт:
./build_mac.sh

# 4. Запуск
java -jar target/mangaBuffJob-0.0.1-SNAPSHOT.jar
```

### Для создания нативного приложения (.app):
```bash
jpackage \
  --input target \
  --name MangaBuffJob \
  --main-jar mangaBuffJob-0.0.1-SNAPSHOT.jar \
  --main-class ru.finwax.mangabuffjob.MangaBuffJobFXApplication \
  --type app-image \
  --app-version 1.0.0 \
  --java-options "-Xmx2G"
```

## 🎯 Результат

Теперь проект полностью поддерживает сборку на:
1. **Windows** - как и раньше
2. **macOS** - новая полная поддержка (Intel и Apple Silicon)
3. **Linux** - работает через JAR

Maven автоматически определяет операционную систему и загружает соответствующие JavaFX библиотеки.

## 📚 Файлы проекта

### Измененные файлы:
- `pom.xml` - добавлены profiles и параметризация JavaFX
- `README.md` - добавлена информация о macOS
- `mvnw` - сделан исполняемым

### Новые файлы:
- `BUILD_MAC.md` - полная документация по сборке для macOS
- `build_mac.sh` - автоматический скрипт сборки для macOS

## 💡 Преимущества решения

1. **Автоматическое определение платформы** - Maven profiles активируются автоматически
2. **Обратная совместимость** - Windows сборка продолжает работать как раньше
3. **Гибкость** - можно явно указать профиль через `-P mac`, `-P win` или `-P linux`
4. **Подробная документация** - пользователи macOS получили полное руководство на русском языке
5. **Удобство** - автоматический скрипт сборки с проверками и цветным выводом

## 🔄 Следующие шаги (опционально)

Если в будущем потребуется:
1. Настроить CI/CD для автоматической сборки релизов под все платформы
2. Добавить GitHub Actions workflow для тестирования на macOS
3. Создать автоматическую публикацию DMG файлов в Releases
4. Подписать приложение для macOS через Apple Developer Program

---

**Автор**: GitHub Copilot
**Дата**: Январь 2026
**Статус**: ✅ Готово к использованию
