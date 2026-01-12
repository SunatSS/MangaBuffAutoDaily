# 🍎 Инструкция по сборке MangaBuffAutoDaily для macOS

Это руководство содержит пошаговые инструкции по сборке приложения MangaBuffAutoDaily на macOS.

## 📋 Системные требования

### Минимальные требования:
- **macOS**: 10.14 (Mojave) или новее (рекомендуется macOS 12+)
- **Процессор**: Intel или Apple Silicon (M1/M2/M3)
- **RAM**: минимум 4 GB
- **Свободное место**: минимум 2 GB

### Необходимое ПО:
1. **JDK 17 или выше** (рекомендуется JDK 21)
2. **Maven 3.6+**
3. **Google Chrome** (последняя версия)

---

## 🔧 Шаг 1: Установка JDK

### Вариант A: Установка через Homebrew (рекомендуется)

```bash
# Установка Homebrew (если еще не установлен)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Установка OpenJDK 21
brew install openjdk@21

# Добавление Java в PATH
echo 'export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Проверка установки
java -version
```

### Вариант B: Установка через официальный сайт

1. Скачайте JDK 21 с официального сайта:
   - [Adoptium (Temurin)](https://adoptium.net/)
   - [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
   
2. Установите скачанный пакет (.dmg или .pkg)

3. Проверьте установку:
```bash
java -version
```

---

## 🔨 Шаг 2: Установка Maven

### Через Homebrew (рекомендуется):

```bash
brew install maven

# Проверка установки
mvn -version
```

### Ручная установка:

1. Скачайте Maven с [официального сайта](https://maven.apache.org/download.cgi)
2. Распакуйте архив:
```bash
tar -xvf apache-maven-*-bin.tar.gz
sudo mv apache-maven-* /opt/maven
```

3. Добавьте Maven в PATH:
```bash
echo 'export PATH="/opt/maven/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

---

## 📦 Шаг 3: Клонирование репозитория

```bash
# Клонирование репозитория
git clone https://github.com/SunatSS/MangaBuffAutoDaily.git
cd MangaBuffAutoDaily
```

---

## 🏗️ Шаг 4: Сборка проекта

### Вариант A: Автоматическая сборка (Maven выберет правильный профиль)

```bash
# Очистка и сборка проекта
./mvnw clean package

# Или используя установленный Maven
mvn clean package
```

### Вариант B: Явное указание профиля macOS

```bash
# Сборка с явным указанием профиля для macOS
./mvnw clean package -P mac

# Пропуск тестов (для ускорения сборки)
./mvnw clean package -P mac -DskipTests
```

### Результат сборки

После успешной сборки, JAR-файл будет находиться в:
```
target/mangaBuffJob-0.0.1-SNAPSHOT.jar
```

---

## 🚀 Шаг 5: Запуск приложения

### Запуск из командной строки:

```bash
java -jar target/mangaBuffJob-0.0.1-SNAPSHOT.jar
```

### Запуск с увеличенной памятью (рекомендуется):

```bash
java -Xmx2G -jar target/mangaBuffJob-0.0.1-SNAPSHOT.jar
```

### Создание скрипта запуска:

Создайте файл `run.sh`:

```bash
#!/bin/bash
java -Xmx2G -Dfile.encoding=UTF-8 -jar target/mangaBuffJob-0.0.1-SNAPSHOT.jar
```

Сделайте его исполняемым:

```bash
chmod +x run.sh
./run.sh
```

---

## 📱 Шаг 6: Создание нативного приложения (.app) [Опционально]

Для создания полноценного macOS приложения с двойным кликом:

### Использование jpackage (JDK 14+):

```bash
# Сборка приложения
./mvnw clean package

# Создание .app пакета
jpackage \
  --input target \
  --name MangaBuffJob \
  --main-jar mangaBuffJob-0.0.1-SNAPSHOT.jar \
  --main-class ru.finwax.mangabuffjob.MangaBuffJobFXApplication \
  --type app-image \
  --app-version 1.0.0 \
  --vendor "MangaBuff Team" \
  --description "Автоматизация для MangaBuff" \
  --java-options "-Xmx2G" \
  --java-options "-Dfile.encoding=UTF-8"
```

После выполнения, приложение `MangaBuffJob.app` появится в текущей директории.

### Создание DMG установщика:

```bash
jpackage \
  --input target \
  --name MangaBuffJob \
  --main-jar mangaBuffJob-0.0.1-SNAPSHOT.jar \
  --main-class ru.finwax.mangabuffjob.MangaBuffJobFXApplication \
  --type dmg \
  --app-version 1.0.0 \
  --vendor "MangaBuff Team" \
  --description "Автоматизация для MangaBuff" \
  --java-options "-Xmx2G" \
  --java-options "-Dfile.encoding=UTF-8"
```

---

## 🔍 Решение возможных проблем

### Проблема: "Command not found: java"

**Решение**: Убедитесь, что Java правильно установлена и добавлена в PATH:
```bash
echo $JAVA_HOME
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
```

### Проблема: "JAVA_HOME is not set"

**Решение**: Установите переменную окружения:
```bash
export JAVA_HOME=$(/usr/libexec/java_home)
echo 'export JAVA_HOME=$(/usr/libexec/java_home)' >> ~/.zshrc
source ~/.zshrc
```

### Проблема: Ошибка сборки с JavaFX

**Решение**: Убедитесь, что используется правильный профиль:
```bash
./mvnw clean package -P mac
```

### Проблема: Chrome WebDriver не найден

**Решение**: Установите Google Chrome:
```bash
brew install --cask google-chrome
```

### Проблема: Недостаточно памяти

**Решение**: Увеличьте heap memory:
```bash
export MAVEN_OPTS="-Xmx2048m"
./mvnw clean package
```

### Проблема: Приложение не запускается из Finder (Gatekeeper)

**Решение**: Разрешите запуск приложения:
```bash
xattr -cr MangaBuffJob.app
```

Или через Системные настройки:
1. Откройте "Системные настройки" → "Конфиденциальность и безопасность"
2. Найдите блокированное приложение и нажмите "Все равно открыть"

### Проблема: Apple Silicon (M1/M2/M3) - низкая производительность

**Решение**: Используйте нативную версию JDK для ARM64:
```bash
# Проверьте архитектуру JDK
java -version | grep "aarch64"

# Если нет, установите ARM версию
brew install --cask temurin@21
```

---

## 🧪 Проверка сборки

После сборки выполните базовую проверку:

```bash
# Проверка структуры JAR
jar -tf target/mangaBuffJob-0.0.1-SNAPSHOT.jar | grep -i javafx

# Запуск с выводом версии
java -jar target/mangaBuffJob-0.0.1-SNAPSHOT.jar --version

# Проверка зависимостей
./mvnw dependency:tree | grep javafx
```

---

## 📝 Дополнительные команды Maven

```bash
# Очистка проекта
./mvnw clean

# Компиляция без сборки JAR
./mvnw compile

# Запуск тестов
./mvnw test

# Установка в локальный репозиторий Maven
./mvnw install

# Просмотр дерева зависимостей
./mvnw dependency:tree

# Обновление зависимостей
./mvnw versions:display-dependency-updates
```

---

## 🎯 Быстрый старт (TL;DR)

```bash
# Установка всего необходимого через Homebrew
brew install openjdk@21 maven
brew install --cask google-chrome

# Клонирование и сборка
git clone https://github.com/SunatSS/MangaBuffAutoDaily.git
cd MangaBuffAutoDaily
./mvnw clean package -P mac

# Запуск
java -jar target/mangaBuffJob-0.0.1-SNAPSHOT.jar
```

---

## 🏗️ Архитектура и зависимости

Проект использует:
- **Java 17+** - основной язык программирования
- **Spring Boot 3.4.4** - фреймворк и планировщик задач
- **JavaFX 21** - графический интерфейс (с поддержкой macOS)
- **Selenium 4.32.0** - автоматизация браузера
- **H2 Database** - встроенная база данных
- **Maven** - система сборки

---

## 📚 Дополнительные ресурсы

- [Документация JavaFX для macOS](https://openjfx.io/openjfx-docs/)
- [Maven на macOS](https://maven.apache.org/install.html)
- [Selenium WebDriver](https://www.selenium.dev/documentation/)
- [Spring Boot Documentation](https://docs.spring.io/spring-boot/docs/current/reference/html/)

---

## 💡 Советы по оптимизации

1. **Для разработки**: Используйте IntelliJ IDEA с плагином JavaFX Scene Builder
2. **Для CI/CD**: Настройте GitHub Actions для автоматической сборки
3. **Для производительности**: Используйте профили Maven для различных окружений
4. **Для распространения**: Создайте DMG установщик через jpackage

---

## ⚠️ Важные замечания

1. **Приложение требует Google Chrome** - убедитесь, что он установлен
2. **Используйте VPN/прокси** при скрапинге манги (как указано в README)
3. **JDK 21 рекомендуется**, но работает и на JDK 17
4. **Apple Silicon (M1/M2/M3)** - используйте ARM версию JDK для лучшей производительности

---

## 📞 Поддержка

При возникновении проблем:
- Telegram канал: https://t.me/mangaBuffBotSupport
- Email: n-kubyshkin@yandex.ru
- GitHub Issues: https://github.com/SunatSS/MangaBuffAutoDaily/issues

---

**Последнее обновление**: Январь 2026
**Версия документа**: 1.0
