# Docker — интерактивный учебник-практикум

**Docker** — платформа контейнеризации, которая упаковывает приложение со всеми зависимостями в изолированный контейнер. Контейнер запускается одинаково на любом компьютере — локально, на сервере или в облаке. Docker решает проблему «у меня работает, а у тебя — нет» и стал стандартом для деплоя серверных приложений и микросервисов.

Учебник-практикум для новичков: теория → ASCII-схема → «Попробуй сам» → «Задание» → «Самопроверка». Все примеры проверены для **Docker Engine 26+** (включая Docker 29) и **Docker Compose v2** (команда `docker compose`, устаревшая `docker-compose` больше не нужна).

> Импортируется в Joplin и Obsidian как обычный Markdown. Якорные ссылки в оглавлении строчные, пробелы заменены на `-`.

## Содержание

- [1. Что такое Docker и зачем он нужен](#1-что-такое-docker-и-зачем-он-нужен)
- [2. Установка Docker](#2-установка-docker)
- [3. Проверка установки и первый контейнер](#3-проверка-установки-и-первый-контейнер)
- [4. Основные команды Docker](#4-основные-команды-docker)
- [5. Запуск первого веб-контейнера nginx](#5-запуск-первого-веб-контейнера-nginx)
- [6. Dockerfile от А до Я](#6-dockerfile-от-а-до-я)
- [7. Сборка образа и слои](#7-сборка-образа-и-слои)
- [8. Кэширование слоёв](#8-кэширование-слоёв)
- [9. Docker Compose](#9-docker-compose)
- [10. Тома и хранение данных](#10-тома-и-хранение-данных)
- [11. Сети Docker](#11-сети-docker)
- [12. Реестр образов и Docker Hub](#12-реестр-образов-и-docker-hub)
- [13. Docker Swarm кратко](#13-docker-swarm-кратко)
- [14. Многоступенчатые сборки](#14-многоступенчатые-сборки)
- [15. Безопасность Docker](#15-безопасность-docker)
- [16. Оптимизация размера образа](#16-оптимизация-размера-образа)
- [17. Проекты-практикумы](#17-проекты-практикумы)
- [18. Практика и задания](#18-практика-и-задания)
- [19. Онлайн-тренажеры и ресурсы](#19-онлайн-тренажеры-и-ресурсы)
- [20. Литература и ссылки](#20-литература-и-ссылки)

---

## 1. Что такое Docker и зачем он нужен

**Теория.** Docker — это инструмент для *контейнеризации*: он упаковывает приложение вместе со всеми его зависимостями (библиотеки, рантайм, настройки, конфиги) в изолированный «контейнер». Контейнер работает одинаково на любом сервере, где есть Docker: «у меня всё работало» перестаёт зависеть от окружения.

Три базовых понятия:

- **Image (образ)** — неизменяемый шаблон: файловая система + настройки + команда запуска. Образ — как «ISO-диск» или «чертёж».
- **Container (контейнер)** — запущенный экземпляр образа: живой процесс с собственным окружением. Из одного образа можно запустить десятки контейнеров.
- **Registry (реестр)** — склад образов. Оттуда образ скачивается (`docker pull`), туда он загружается (`docker push`). Главный публичный реестр — Docker Hub.

Чем контейнер отличается от виртуальной машины: VM эмулирует целую машину с ОС (гигабайты, минуты на старт), контейнер использует ядро хоста и изолирует только процессы (мегабайты, секунды на старт).

### Чем Docker отличается от Snap, Flatpak и AppImage

Snap, Flatpak и AppImage — это форматы упаковки **десктопных приложений** для Linux, а Docker — инструмент контейнеризации **серверных сервисов**.

| Технология | Назначение | Изоляция | Обновления | Особенности |
| --- | --- | --- | --- | --- |
| Snap | Десктопные и серверные пакеты | sandbox (AppArmor), демон snapd | Автоматические, атомарные | Централизованный магазин Snap Store |
| Flatpak | Графические приложения | sandbox (Bubblewrap) | Через Flathub | Настраиваемые разрешения, большие рантаймы |
| AppImage | Портативные утилиты | Практически нет | Нет (вручную) | Один файл, запуск без установки |
| Docker | Серверы, микросервисы, деплой | Полная изоляция окружения | Образы пересобирают | Требует настройки, не для десктопа |

### Docker и Podman

**Podman** — контейнерный движок без демона, альтернатива Docker, разработанный Red Hat. Команды почти полностью совместимы: `podman run` ≈ `docker run`.

| Критерий | Docker | Podman |
| --- | --- | --- |
| Архитектура | Демон `dockerd` (root-процесс) + клиент CLI | Без демона, «fork-exec», процессы — обычные дочерние процессы |
| Rootless | Работает, но с дополнительными шагами | Поддержка rootless из коробки |
| Использование в rootless-режиме | Нужна настройка (dockerd-rootless) | Дефолт в Fedora/RHEL |
| Формат образов | OCI (по умолчанию Docker) | OCI |
| Совместимость с Docker CLI | Эталон | В основном полная (`alias docker=podman`) |
| Команда для группы контейнеров | `docker compose` | `podman-compose` или интеграция Podman Desktop |
| Запуск со своей ОС | — | Podman Machine (macOS/Windows) |
| Экосистема | Огромная, де-факто стандарт | Растёт (Fedora, RHEL, OpenShift) |

Практический совет новичку: **начинайте с Docker** — больше документации и примеров, всё работает «из коробки». Если понадобится rootless-контейнеры без демона и с правами обычного пользователя — присмотритесь к Podman.

**Схема — образ, контейнер, реестр:**

```
┌─────────────────── Registry (реестр) — «склад образов» ───────────────────┐
│   Docker Hub · GHCR · приватный реестр                                     │
│   ubuntu:24.04   nginx:1.27   yourname/myapp:v1                            │
└───────────────┬──────────────────────────────────┬─────────────────────────┘
                │ docker pull (скачать образ)       │ docker push (загрузить)
                ▼                                    ▲
┌───────────────────────── Docker Engine (хост) ─────────────────────────────┐
│   ┌────────────────── Image (образ) ─────────────────────┐                 │
│   │   неизменяемый шаблон: слои файловой системы +        │                 │
│   │   + команда запуска (dockerfile → docker build)        │                 │
│   └────────────────────────┬─────────────────────────────┘                 │
│                            │ docker run (из образа создаётся контейнер)    │
│                            ▼                                               │
│   ┌────────────────── Container (контейнер) ───────────────┐               │
│   │   работающий процесс + свой тонкий слой записи          │               │
│   └────────────────────────────────────────────────────────┘               │
└────────────────────────────────────────────────────────────────────────────┘
```

### Попробуй сам
```shell
docker --version          # версия клиента
docker run hello-world    # скачать и запустить тестовый образ
```

### Задание

1. Объясни своими словами (можно письменно): почему два программиста с одинаковым «кусочком кода» и разными машинами получают одинаковый результат, если используют Docker? Где «живёт» скачанный образ — в контейнере или в реестре?

### Самопроверка
**Ответ:**

- Docker замораживает окружение: зависимости и конфигурация упакованы в образ, поэтому результат не зависит от машины.
- Образ хранится локально (на Docker-хосте) после `docker pull` и в реестре — на сервере. Контейнер — лишь запущенный экземпляр образа, а не место хранения.

---

## 2. Установка Docker

**Теория.** Docker состоит из демона (`dockerd` — служба-«сервер») и клиента (`docker` — команда в терминале). На Linux демон ставится как системная служба (systemd). После установки пользователь добавляется в группу `docker`, чтобы не вводить `sudo` перед каждой командой.

> Проверено на Docker Engine 26+. Официальные инструкции — на https://docs.docker.com/engine/install/.

### Попробуй сам

Ubuntu / Debian (официальный репозиторий):
```shell
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# для Debian в строке ниже замените ubuntu на debian
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Arch / Manjaro:
```shell
sudo pacman -Syu
sudo pacman -S docker docker-compose docker-buildx
sudo systemctl enable --now docker
```

Fedora:
```shell
sudo dnf -y install dnf-plugins-core
sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
```

ALT Linux (порядок пакетов может отличаться — уточняй поиском):
```shell
sudo apt-get update
apt-cache search docker          # найти имя пакета, часто docker-engine
sudo apt-get install docker-engine docker-compose
sudo systemctl enable docker
sudo systemctl start docker
```

Права для обычного пользователя (обязательно после установки):
```shell
sudo systemctl enable docker    # автозапуск при старте системы
sudo systemctl start docker     # запустить сейчас
sudo usermod -aG docker $USER   # добавить себя в группу docker
# варианты добавления в группу:
#   gpasswd -a $USER docker
```

После `usermod` — **выйди из системы и зайди снова** (или выполни `newgrp docker`), иначе права не применились.

Если после этого Docker-клиенту не хватает прав (редко, на нестандартных настройках):
```shell
sudo setfacl --modify user:$(whoami):rw /var/run/docker.sock
```

> Внимание: доступ к группе `docker` и к `/var/run/docker.sock` фактически равен root-доступу к системе — не давайте его всем подряд.

### Задание

1. Установи Docker, добавь себя в группу, перезайди в сессию и перейди к разделу 3. Запиши в заметку, какой командой у тебя устанавливается служба в твоём дистрибутиве.

### Самопроверка
**Ответ:**

Признаки успешной установки:
- `systemctl is-active docker` печатает `active`;
- `docker info` показывает версию сервера и не ругается на права;
- команды `docker ...` работают **без** `sudo`.
Если появляется `permission denied while trying to connect to the Docker daemon socket` — не выполнено `usermod -aG docker` + перезаход в систему.

---

## 3. Проверка установки и первый контейнер

**Теория.** Первая проверка — версии клиента и сервера. Если видишь обе части (`Client` и `Server`), значит демон работает. Затем «Hello World» Docker: образ, который запускает контейнер, печатает приветствие и завершает работу.

**Схема — что происходит при `docker run hello-world`:**

```
docker run hello-world
      │
      ├─► 1. Образ hello-world есть локально? → НЕТ
      │        │
      │        ▼
      │   2. docker pull hello-world (скачать из Docker Hub)
      │              │
      │              ▼
      ├─► 3. Создать контейнер из образа
      │        │
      │        ▼
      └─► 4. Запустить процесс в контейнере → вывести текст → завершиться
```

### Попробуй сам
```shell
docker version                 # версия Client и Server
docker info                    # подробно о демоне (движок, хранилище, контейнеры)
docker run hello-world         # первый контейнер
docker ps -a                   # увидим контейнер hello-world в статусе Exited
docker rm <ИД или ИМЯ>         # убрать его, чтобы не мешал
```

Ожидаемый вывод `docker run hello-world` содержит «Hello from Docker!» и пояснение, что `hello-world` — минимальный образ для проверки.

### Задание

1. Выполни три команды: `docker version`, `docker run hello-world`, `docker ps -a`. Запиши статус контейнера, который ты видишь в последней.

### Самопроверка
**Ответ:**

В `docker version` должны быть две секции: `Client:` и `Server:`. Если `Server` отсутствует — демон не запущен (`sudo systemctl start docker`).
В `docker ps -a` контейнер `hello-world` будет в состоянии `Exited (0)` — он выполнил свою задачу (вывел текст) и корректно завершился; код выхода `0` означает успех.

---

## 4. Основные команды Docker

**Теория.** Ядро Docker-CLI — это команды «существительное + объект»: `docker run`, `docker ps`, `docker logs`, `docker exec`… Все объекты (контейнеры, образы, сети, тома) можно посмотреть списком, удалить, осмотреть.

**Справочная таблица (бери на вооружение):**

| Команда | Что делает | Пример |
| --- | --- | --- |
| `docker run` | создать и запустить контейнер | `docker run -d -p 8080:80 nginx` |
| `docker ps` / `docker ps -a` | список запущенных / всех контейнеров | `docker ps -a` |
| `docker logs` | логи контейнера (`-f` — следить) | `docker logs -f my_nginx` |
| `docker exec` | команда внутри работающего контейнера | `docker exec -it my_nginx bash` |
| `docker attach` | подключиться к главному процессу контейнера | `docker attach my_nginx` |
| `docker stop / start / restart` | управление жизненным циклом | `docker restart my_nginx` |
| `docker rm` / `docker rm -f` | удалить контейнер | `docker rm my_nginx` |
| `docker rmi` | удалить образ | `docker rmi nginx` |
| `docker images` | список локальных образов | `docker images` |
| `docker pull` | скачать образ без запуска | `docker pull alpine:latest` |
| `docker inspect` | детали объекта в JSON | `docker inspect my_nginx` |
| `docker stats` | живой мониторинг CPU/памяти | `docker stats` |
| `docker ps` | (см. выше) | — |
| `docker system prune` | очистить неиспользуемые объекты | `docker system prune -a` |
| `docker system df` | сколько места занимает Docker | `docker system df` |
| `docker cp` | копирование файлов из/в контейнер | `docker cp my_cont:/app/log ./log` |
| `docker save` | сохранить образ в tar-файл | `docker save -o ubuntu.tar ubuntu` |
| `docker load` | загрузить образ из tar-файла | `docker load -i ubuntu.tar` |
| `docker buildx build` | мультиплатформенная сборка | `docker buildx build --platform linux/amd64,linux/arm64 .` |

**Пример: список IP-адресов всех работающих контейнеров:**

```bash
for ID in $(docker ps -q | awk '{print $1}'); do
    IP=$(docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" "$ID")
    NAME=$(docker ps | grep "$ID" | awk '{print $NF}')
    printf "%s %s\n" "$IP" "$NAME"
done
```

### Попробуй сам
```shell
docker pull alpine:latest            # скачать миниатюрный Linux-образ (~7 МБ)
docker run -it alpine sh             # интерактивно: консоль внутри контейнера
# внутри:  ls /   -- файловая система контейнера
# внутри:  exit  -- выйти и остановить контейнер
docker ps -a                         # контейнер остался в списке (Exited)
docker run -d --name my_nginx nginx  # фоновый запуск + имя
docker ps                            # my_nginx работает
docker logs my_nginx                 # логи nginx
docker exec -it my_nginx bash        # терминал внутрь работающего nginx
# внутри:  ls /etc/nginx && exit
docker stop my_nginx                 # остановить
docker start my_nginx                # запустить снова
docker restart my_nginx              # перезапустить
docker stats                         # посмотреть потребление (Ctrl+C для выхода)
docker inspect my_nginx              # полное описание в JSON
docker rm -f my_nginx                # принудительно удалить
```

**Основные флаги `docker run`:**

| Флаг | Назначение | Пример |
| --- | --- | --- |
| `-d` | фоном (detach) | `docker run -d nginx` |
| `-p HOST:CONTAINER` | проброс порта | `docker run -p 8080:80 nginx` |
| `--name` | имя контейнера | `docker run --name web nginx` |
| `-v HOST:CONTAINER` | том / монтирование папки | `docker run -v /home/als/www:/usr/share/nginx/html nginx` |
| `--rm` | удалить после остановки | `docker run --rm -it alpine sh` |
| `-e KEY=VALUE` | переменная окружения | `docker run -e MYSQL_ROOT_PASSWORD=root mysql:8` |
| `-it` | интерактивный терминал | `docker run -it ubuntu bash` |

> Копируй команды по одной и сверяй вывод. `Ctrl+C` прерывает процесс контейнера, `exit` — выход из его консоли.

### Задание

1. Запусти `docker run -d --name book_web -p 8081:80 nginx` и открой в браузере `http://localhost:8081` — увидишь страницу «Welcome to nginx!». Потом посмотри логи: `docker logs book_web`.

2. Запусти `docker run --rm -it alpine sh` и внутри выполни `uname -a`, `cat /etc/os-release`. Затем `exit`. В чём отличие от запуска без `--rm`? Проверь `docker ps -a` после выхода.

### Самопроверка
**Ответ:**

Задание 1: браузер открывает страницу welcome to nginx; `docker logs` показывает строки access log (запросы от браузера) и error log.

Задание 2: `--rm` удаляет контейнер сразу после остановки, поэтому в `docker ps -a` его нет. Без `--rm` контейнер остался бы в списке как `Exited`. `alpine` — минимальный Linux, `cat /etc/os-release` показывает `NAME="Alpine Linux"` (musl вместо glibc).

---

## 5. Запуск первого веб-контейнера nginx

**Теория.** nginx — популярный веб-сервер. Его официальный образ служит классическим «первым веб-приложением»: контейнер слушает порт 80, а мы пробрасываем на него свободный порт хоста. Порт хоста выбираем вне стандартных (8080), чтобы не конфликтовать с другими сервисами.

**Схема проброса порта:**

```
            Ваш браузер
                 │
                 │  http://localhost:8080
                 ▼
      ┌────────────────── Хост ──────────────────┐
      │   порт 8080 (браузер)                    │
      │        │  -p 8080:80                     │
      │        ▼                                 │
      │   ┌──────────────┐                       │
      │   │  контейнер   │  порт 80              │
      │   │    nginx     │  «Welcome to nginx!»  │
      │   └──────────────┘                       │
      └───────────────────────────────────────────┘
   Внутри контейнера сеть своя: приложение живёт на "80",
   наружу мы выставляем произвольный порт хоста.
```

### Попробуй сам
```shell
docker run -d --name my_site -p 8080:80 nginx
docker ps
# открыть http://localhost:8080
docker logs my_site
docker exec -it my_site bash
# внутри: ls /usr/share/nginx/html && cat /usr/share/nginx/html/index.html && exit
docker stop my_site
docker rm my_site
```

Свою страницу вместо стандартной положишь через том (раздел 10):
```shell
mkdir -p ~/www
echo '<h1>Привет, Docker!</h1>' > ~/www/index.html
docker run -d --name my_site -p 8080:80 -v ~/www:/usr/share/nginx/html:ro nginx
# :ro — read-only, контейнер не сможет менять файлы хоста
```

### Задание

1. Разверни nginx так, чтобы на `http://localhost:8090` отдавалась твоя собственная HTML-страница (используй `-v` и каталог `~/www`).

### Самопроверка
**Ответ:**

- Контейнер должен быть в `docker ps` в статусе `Up`.
- В браузере по `http://localhost:8090` — твой HTML, а не стандартный welcome-nginx (значит, том подключён корректно).
- Если страница старая — возможно, браузер кэширует: нажми `Ctrl+Shift+R`. Если порт занят — смени на 8091 и перезапусти.

---

## 6. Dockerfile от А до Я

**Теория.** `Dockerfile` — текстовый скрипт сборки образа. Каждая инструкция создаёт один слой. Порядок важен: сначала то, что меняется редко (зависимости), потом — код.

**Все ключевые инструкции:**

| Инструкция | Назначение |
| --- | --- |
| `FROM` | базовый образ (обязательная первая строка) |
| `RUN` | команда на этапе сборки (установка пакетов) |
| `WORKDIR` | рабочая директория для следующих инструкций |
| `COPY` | скопировать файлы хоста в образ |
| `ADD` | как `COPY`, но умеет распаковывать архивы и скачивать URL (для простого копирования старайся использовать `COPY`) |
| `CMD` | команда по умолчанию при запуске (можно переопределить) |
| `ENTRYPOINT` | неотменяемая главная команда (обычно в exec-форме) |
| `EXPOSE` | документация: какой порт слушает приложение |
| `ENV` | переменная окружения (видна в контейнере) |
| `ARG` | переменная только на этапе сборки (`docker build --build-arg`) |
| `LABEL` | метаданные образа (поддерживающий, версия) |
| `VOLUME` | точка монтирования для данных извне |
| `HEALTHCHECK` | проверка «жив ли» контейнер |
| `USER` | пользователь, под которым идёт процесс |
| `.dockerignore` | файл (не инструкция) с исключениями из контекста сборки |

**ADD vs COPY:**
`ADD` — расширение `COPY`: умеет извлекать локальные tar-архивы и скачивать по URL, но **предпочитайте `COPY`**: поведение `ADD` с URL и архивами неожиданно, а неявная распаковка мешает кэшированию.

```dockerfile
COPY package*.json ./
COPY . .
COPY --from=builder /app/myapp .   # из промежуточной стадии многоступенчатой сборки
```

**Формы `CMD` и `ENTRYPOINT`:**
- exec-форма (список): `CMD ["nginx", "-g", "daemon off;"]` — рекомендуется;
- shell-форма (строка): `CMD nginx -g "daemon off;"` — выполняется через `/bin/sh -c`.

Связка `ENTRYPOINT + CMD`: `ENTRYPOINT ["nginx"]` фиксирует программу, `CMD ["-g", "daemon off;"]` задаёт аргументы по умолчанию. Тогда `docker run image -s` переопределит только `CMD`, но не замену программы.

**Пример полноценного Dockerfile (Node.js приложение):**

```dockerfile
# 1. Базовый образ (последняя LTS-версия Node на Alpine)
FROM node:22-alpine

# 2. Метаданные образа
LABEL maintainer="you@example.com" \
      version="1.0"

# 3. Аргумент сборки (не попадает в образ)
ARG NODE_ENV=production

# 4. Переменные окружения внутри контейнера
ENV NODE_ENV=$NODE_ENV

# 5. Рабочая директория
WORKDIR /app

# 6. Сначала — только файл зависимостей: он меняется редко
COPY package.json package-lock.json ./

# 7. Установка (кэш трогать не будем — см. раздел 8)
RUN npm ci --omit=dev

# 8. Теперь — код приложения
COPY . .

# 9. Не запускать от root: создать пользователя и переключиться
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# 10. Порт, который слушает приложение
EXPOSE 3000

# 11. Проверка здоровья контейнера
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1:3000/health || exit 1

# 12. Команда запуска (exec-форма)
CMD ["node", "app.js"]
```

Файл `.dockerignore` в той же папке:

```text
node_modules
npm-debug.log
Dockerfile
.dockerignore
.git
.env
*.md
```

**Схема — что создаёт каждая строка Dockerfile:**

```
              Dockerfile                        Слои образа
┌──────────────────────────────┐      ┌───────────────────────────┐
│ FROM node:22-alpine          │───▶  │ слой: базовый образ (…слои)│
│ WORKDIR /app                 │───▶  │ слой: рабочая директория  │
│ COPY package*.json ./        │───▶  │ слой: пакеты проекта      │
│ RUN npm ci --omit=dev        │───▶  │ слой: установленные модули│
│ COPY . .                     │───▶  │ слой: исходный код        │
│ USER appuser                 │───▶  │ слой: учетная запись      │
│ CMD ["node","app.js"]        │───▶  │ мета-слой: команда запуска│
└──────────────────────────────┘      └───────────────────────────┘
  docker build -t myapp .                  готовый образ myapp
```

### Попробуй сам

Создай папку проекта:
```shell
mkdir -p ~/myapp && cd ~/myapp
```

Минимальный Dockerfile:
```dockerfile
FROM alpine:latest
RUN apk add --no-cache curl
CMD ["sh", "-c", "echo Привет из моего образа! && curl --version | head -1"]
```

Сборка и запуск:
```shell
docker build -t my-hello .
docker run --rm my-hello
docker images                      # посмотреть размер и слои
docker history my-hello            # история инструкций (слоёв)
```

### Задание

1. Собери образ `my-hello` по примеру выше и запусти. Убедись, что `docker history` показывает каждую инструкцию Dockerfile отдельной строкой.

2. Доработай Dockerfile: добавь `EXPOSE 80`, запусти в нём `nginx` вместо curl (базовый образ можно взять `nginx:alpine`), пробрось порт и открой в браузере. Подсказка: образ `nginx:alpine` уже содержит nginx, достаточно `docker run -d -p 8080:80 nginx:alpine`.

### Самопроверка
**Ответ:**

Задание 1: `docker history my-hello` показывает строки вида `ADD file:…`, `RUN /bin/sh -c apk add…`, `CMD ["sh","-c",…]` — это и есть слои. Чем меньше слоёв и их размер, тем компактнее образ.

Задание 2: `nginx:alpine` — готовый образ веб-сервера; `docker run -d -p 8080:80 nginx:alpine` даёт страницу welcome to nginx, как в разделе 5, только из другого образа с исходниками. `EXPOSE` — только документация; без `-p 8080:80` наружу порт всё равно не откроется.

---

## 7. Сборка образа и слои

**Теория.** Образ — это стопка слоёв. Каждый слой — результат одной инструкции `FROM`/`RUN`/`COPY`/`ADD`. Слои *копируются и переиспользуются*: если в двух образах совпадает базовый слой, он скачивается один раз (поэтому обновлять теги `latest` бездумно — антипаттерн).

Контейнер, запущенный из образа, получает *ещё один* слой — слой записи (writable). Все изменения контейнера попадают туда и исчезают при `docker rm` (если не сохранить их в образ через `docker commit` — но это редкий рабочий приём, обычно правят Dockerfile).

**Схема слоёв образа и контейнера:**

```
                 IMAGE (только чтение)                  CONTAINER
   ┌────────────────────────────────────────┐   ┌──────────────────────┐
   │  CMD  (команда запуска)                │   │  ┌────────────────┐  │
   │  COPY . .   (исходный код)             │   │  │ writable-слой  │  │  ← новые файлы,
   │  RUN npm ci (зависимости)              │   │  │ (изменения     │  │    правки, логи
   │  COPY package.json                     │   │  │  контейнера)   │  │    живут ВКОНТЕЙНЕРЕ
   │  FROM node:22-alpine (уже много слоёв) │   │  └────────────────┘  │
   └────────────────────────────────────────┘   │  ┌────────────────┐  │
                                               │  │  слои образа    │  │  ← не меняются
                                               │  └────────────────┘  │
                                               └──────────────────────┘
   docker build создаёт слои образа; docker run добавляет слой записи
```

### Попробуй сам
```shell
docker build -t my-hello .
docker history my-hello          # какие слои и их размер (против Installed size)
docker inspect my-hello          # JSON: Layers — список слоёв (sha256:…)
docker run -d --name tmp_alpine alpine sleep 300
docker diff tmp_alpine           # что контейнер изменил поверх образа
docker commit tmp_alpine my-alpine-with-changes   # (редкий приём, для сведения)
docker rm -f tmp_alpine
```

### Задание

1. Собери `my-hello`, посмотри `docker history` и `docker inspect`. Запиши: сколько слоёв у образа и какова суммарная «Installed size».

### Самопроверка
**Ответ:**

Слоёв столько, сколько «изменяющих файлы» инструкций (базовый образ приносит свои слои). `docker inspect .Layers` покажет список идентификаторов слоёв; суммарный размер слоёв ≈ размеру образа. Изменения `docker diff` для `sleep`-контейнера обычно пустые, `docker commit` фиксирует их как новый образ.

---

## 8. Кэширование слоёв

**Теория.** При повторной сборке Docker использует кэш слоёв: если инструкция не менялась и её входные данные (скажем, содержимое `package.json`) прежние — слой берётся из кэша, а не пересоздаётся. Но любое изменение в раннем слое инвалидирует **все** следующие.

Правило: **неизменяемое — раньше, изменяемое — позже.** Сначала `COPY package.json`, потом `RUN npm ci`, и только потом `COPY . .` (код). Иначе любая правка кода заставляла бы заново ставить все зависимости.

Ещё рекомендации:
- комбинируй установку в один `RUN` — меньше слоёв и чище кэш;
- для apt: `RUN apt-get update && apt-get install -y ... && rm -rf /var/lib/apt/lists/*` в одном операторе;
- для pip: `pip install --no-cache-dir -r requirements.txt`.

**Схема кэша:**

```
Сборка 1-я                    Сборка 2-я (изменился только код app.js)
┌ FROM node:22-alpine  ─┐    ┌ FROM node:22-alpine  ── КЭШ ✓
├ COPY package.json     ├─►  ├ COPY package.json     ── КЭШ ✓ (не менялся)
├ RUN npm ci            ├─►  ├ RUN npm ci            ── КЭШ ✓
├ COPY . .  (код)       ├─►  ├ COPY . .  (код)       ── пересборка
└ CMD [..]              ┘    └ CMD [..]              ── КЭШ ✓
 Полная сборка                Быстрая: только копирование кода
```

### Попробуй сам
```shell
cd ~/myapp
docker build -t my-hello .     # первая сборка — все слои новые
echo 'console.log(1)' > app.txt    # изменишь содержимое той папки
docker build -t my-hello .     # вторая — проверь, какие слои CACHED
docker build -t my-hello .     # третья, без изменений — всё кэш
```

### Задание

1. Посмотри вывод второй сборки: какие шаги показаны как `CACHED`, а какой пересобран. Затем скопируй `node_modules` в папку и посмотри, как он попадёт в контекст — теперь подключи правильный `.dockerignore` (раздел 6) и собери ещё раз.

### Самопроверка
**Ответ:**

- `CACHED` означает: слой взят из кэша, результирующий вывод совпадает по содержимому входа.
- Если `.dockerignore` не подключён, в контекст сборки попадает всё, включая `node_modules` (сотни МБ и долгая отправка демону). После добавления `.dockerignore` контекст худеет, а слой `COPY . .` собирается быстро.
- Готовый трюк для безопасности сборки: никогда не копируй `.env` (он в `.dockerignore`).

---

## 9. Docker Compose

**Теория.** Compose (v2, команда `docker compose`) описывает приложение «из нескольких сервисов» в YAML-файле `compose.yaml` (или `docker-compose.yml`) и управляет им одной командой. Один сервис = один контейнер. Compose сам создаёт сеть, по которой сервисы видят друг друга под своими именами.

Ключевые поля `services`:

| Поле | Назначение |
| --- | --- |
| `image` / `build` | готовый образ / собрать из Dockerfile |
| `ports` | проброс портов `"HOST:CONTAINER"` |
| `environment` | переменные окружения |
| `volumes` | тома и монтирования |
| `depends_on` | порядок и зависимость запуска |
| `restart` | политика перезапуска: `no`, `always`, `on-failure`, `unless-stopped` |
| `container_name` | зафиксировать имя контейнера (не обязательно) |

> В формате Compose v2 строка `version:` **устарела** — не пиши её.
> `depends_on` гарантирует порядок запуска, но **не** готовность сервиса (для БД добавь в приложение ожидание соединения).

**Схема — веб + БД:**

```
        compose.yaml  (web + db)
┌──────────────────────────────────────────────────┐
│   network: app-net                               │
│   ┌────────────┐        ┌──────────────┐         │
│   │ web        │  ───▶  │ db           │         │
│   │ build:.    │        │ postgres:17  │         │
│   │ ports:     │        │ volume: pgdata        │
│   │  "8080:3000│────┐   └──────────────┘         │
│   │ depends_on:│    │   ┌──────────────┐         │
│   │  - db      │    └──▶│ pgdata (том) │ move    │
│   └────────────┘        └──────────────┘         │
└──────────────────────────────────────────────────┘
   web обращается к БД по имени сервиса: postgres://user:pass@db:5432
```

### Попробуй сам

Папка проекта:
```shell
mkdir -p ~/compose-app && cd ~/compose-app
```

`Dockerfile`:
```dockerfile
FROM node:22-alpine
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

`package.json`:
```json
{
  "name": "compose-app",
  "version": "1.0.0",
  "scripts": { "start": "node server.js" },
  "dependencies": { "express": "^4.19.0", "pg": "^8.12.0" }
}
```

`server.js` (минимальный, с ожиданием БД):
```javascript
const express = require('express');
const { Pool } = require('pg');

const app = express();
const pool = new Pool({ connectionString: process.env.DATABASE_URL });

app.get('/health', async (_req, res) => {
  try { await pool.query('SELECT 1'); res.send('db ok'); }
  catch (e) { res.status(503).send('db down'); }
});

app.listen(3000, () => console.log('listening on 3000'));
```

`compose.yaml`:
```yaml
services:
  web:
    build: .
    container_name: compose_web
    restart: unless-stopped
    ports:
      - "8080:3000"
    environment:
      DATABASE_URL: postgres://user:pass@db:5432/mydb
    depends_on:
      - db

  db:
    image: postgres:17-alpine
    container_name: compose_db
    restart: unless-stopped
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: mydb
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

**Схема — что происходит после `docker compose up`:**

```
   docker-compose.yml ──► docker compose up -d ──►
        │
        ▼
   ┌────────────────────────── проект: myapp ──────────────────────────┐
   │  СЕТЬ: myapp_default (bridge)                                     │
   │                                                                    │
   │    ┌────────────┐      http://db:5432      ┌────────────┐         │
   │    │  web        │  ◄────────────────────►  │  db        │         │
   │    │  nginx      │                          │  postgres  │         │
   │    │  8080:3000  │                          │  volume:   │         │
   │    │  depends_on │                          │  pgdata    │         │
   │    │  healthcheck│                          │  healthcheck│        │
   │    └────────────┘                          └────────────┘         │
   │                                      тома: myapp_pgdata           │
   └──────────────────────────────────────────────────────────────────┘
```

Запуск:
```shell
docker compose up -d            # собрать и запустить всё
docker compose ps               # статус сервисов
docker compose logs -f          # логи всех сервисов (Ctrl+C — выход из слежки)
docker compose logs web
curl http://localhost:8080/health   # → db ok
docker compose down             # остановить
docker compose down -v          # остановить И удалить тома (данные БД уйдут!)
docker compose up -d --build    # пересобрать образы из Dockerfile
```

### Задание

1. Разверни веб+БД из примера. Убедись, что `http://localhost:8080/health` отвечает `db ok`. Останови `db` (`docker compose stop db`) и обнови страницу — приложение должно отвечать `db down` (это показывает, почему `depends_on` не спасает от недоступной БД во время работы).

2. Добавь сервис `redis` (образ `redis:7-alpine`) и поле `depends_on` для `web`. Перезапусти стек и посмотри `docker compose ps`.

### Самопроверка
**Ответ:**

- `docker compose up -d` запускает контейнеры в порядке зависимостей; `-d` — фоном.
- `curl …/health` = `db ok` — web достучался до postgres по имени `db` (это и есть встроенный DNS Compose-сети).
- `docker compose down -v` удаляет named-volume `pgdata` — данные БД теряются.
- `depends_on` влияет только на порядок запуска, а не на готовность; поэтому в приложении нужна проверка соединения (в примере — `pool.query` в `/health`).

---

## 10. Тома и хранение данных

**Теория.** Слой записи контейнера живёт, пока жив контейнер: удалил контейнер — потерял данные. Чтобы данные переживали контейнеры и использовались несколькими контейнерами, существуют тома и монтирования:

- **Named volume** — именованный том, которым управляет Docker (данные лежат в `/var/lib/docker/volumes/<имя>/_data`). Удобен для БД и рабочих данных.
- **Bind mount** — прямая привязка папки хоста (`-v /home/als/www:/usr/share/nginx/html`). Удобен для разработки (редактируешь на хосте — контейнер видит сразу) и статики.
- **tmpfs** — временная память, живёт пока контейнер запущен (данные теряются при остановке).

**Схема двух типов:**

```
  Named volume (управляет Docker)          Bind mount (папка хоста)
┌────────── host ──────────┐   ┌────────── host ──────────────────────┐
│ /var/lib/docker/volumes/ │   │ /home/als/www   (твои файлы)         │
│   mydata/_data           │   │   ├─ index.html                     │
│         │ mount          │   │   └─ assets/                        │
│         ▼                │   │        │  -v ~/www:/usr/share/nginx │
│  ┌──────────────┐        │   │        ▼                            │
│  │ контейнер    │        │   │  ┌──────────────────────┐           │
│  │  /data       │        │   │  │ контейнер            │           │
│  └──────────────┘        │   │  │  /usr/share/nginx/html│          │
└──────────────────────────┘   └──────────────────────────┘          │
   docker volume create mydata    изменения видны с обеих сторон сразу
```

### Попробуй сам
```shell
docker volume create mydata
docker volume ls
docker volume inspect mydata

# named volume в контейнере
docker run -d --name vol_test -v mydata:/data alpine sleep 300
docker exec vol_test sh -c 'echo hello > /data/file.txt'
docker rm -f vol_test

# тот же том в новом контейнере — данные на месте
docker run --rm -v mydata:/data alpine cat /data/file.txt   # → hello

# bind mount
mkdir -p ~/www2 && echo '<h1>bind</h1>' > ~/www2/index.html
docker run -d --name bind_test -p 8082:80 -v ~/www2:/usr/share/nginx/html:ro nginx
rm -f ~/www2/index.html          # правка на хосте мгновенно видна контейнеру

# tmpfs (временные данные в памяти)
docker run --rm --tmpfs /cache alpine sh -c 'echo x > /cache/f && cat /cache/f'

# убрать за собой
docker rm -f bind_test
docker volume rm mydata
```

### Задание

1. Подними `postgres:17-alpine` с named-томом, запиши данные, удали контейнер, подними новый образ с тем же томом и проверь, что данные сохранились:
```shell
docker volume create pgdata
docker run -d --name pg1 -e POSTGRES_PASSWORD=pass -v pgdata:/var/lib/postgresql/data postgres:17-alpine
docker exec pg1 psql -U postgres -c 'create table t(a int); insert into t values (1);'
docker rm -f pg1
docker run -d --name pg2 -e POSTGRES_PASSWORD=pass -v pgdata:/var/lib/postgresql/data postgres:17-alpine
docker exec pg2 psql -U postgres -c 'select * from t;'    # должна вернуть строку (1)
docker rm -f pg2 && docker volume rm pgdata
```

### Самопроверка
**Ответ:**

Данные переживают пересоздание контейнеров, потому что named volume принадлежит Docker, а не контейнеру. `docker exec pg2 psql -U postgres -c 'select * from t;'` возвращает `1` — таблица сохранилась в `pgdata`. Bind mount удобен для разработки (горячая перезагрузка файлов), named volume — для продуманного хранения БД и важных данных.

---

## 11. Сети Docker

**Теория.** По умолчанию каждый контейнер получает изолированную сеть. Docker предоставляет несколько драйверов:

- **bridge** — стандартная мостовая сеть (по умолчанию `docker0`). Контейнеры одной сети видят друг друга; наружу — только через проброс портов `-p`.
- **host** — контейнер делит сетевой стек хоста (никаких пробросов, но и изоляции по портам нет).
- **none** — полная изоляция без сети.

Своя (custom) bridge-сеть даёт встроенный DNS: контейнеры обращаются друг к другу по имени. Это главный способ связи «веб-приложение → БД».

**Схема bridge и host:**

```
  bridge (по умолчанию)                    host
┌──────────────────────────┐   ┌────────────────────────────┐
│      host                │   │        host                │
│  ┌─────────────────────┐ │   │  eth0, lo (тот же стек)    │
│  │    docker0 172.17.x │ │   │  ┌────────────────────┐    │
│  │  ┌─────┐  ┌─────┐   │ │   │  │ контейнер          │    │
│  │  │ app │  │ db  │   │ │   │  │ --network=host     │    │
│  │  └──┬──┘  └──┬──┘   │ │   │  │  app сразу слушает │    │
│  │     └────────┘      │ │   │  │  порты хоста!      │    │
│  │  видят друг друга,  │ │   └────────────────────┘    │
│  │  наружу -p 8080:80  │ │   └──────────────────────────┘
│  └─────────────────────┘ │   без проброса и без изоляции
└──────────────────────────┘
```

**Схема custom network (рекомендуемый способ связи):**

```
   docker network create backend

┌──────────────────────────────────────────────────┐
│   backend  (bridge, 172.18.0.0/16)               │
│   встроенный DNS: имена контейнеров = адреса      │
│   ┌────────────┐        ┌────────────────┐        │
│   │ app        │   ──►  │ db             │        │
│   │ --net back │        │ --net back     │        │
│   │ db:5432    │        │ postgres:17    │        │
│   └────────────┘        └────────────────┘        │
└──────────────────────────────────────────────────┘
   app подключается к БД по имени "db", порт 5432
```

### Попробуй сам
```shell
docker network ls                 # bridge, host, none уже есть
docker network create backend

# два контейнера в своей сети
docker run -d --name db1 --network backend -e POSTGRES_PASSWORD=pass postgres:17-alpine
docker run --rm -it --network backend alpine sh
# внутри контейнера:
#   ping db1 -c 2      (или: getent hosts db1)
#   exit
docker network inspect backend    # посмотреть, кто в сети и их IP

# драйверы для сравнения
docker run --rm --network host alpine sh -c 'head -1 /etc/hosts'
docker run --rm --network none alpine sh -c 'ip a'   # сети нет (busybox: "ip" может отсутствовать)

docker network rm backend         # сначала удали контейнеры
docker rm -f db1
```

### Задание

1. Подними в одной кастомной сети два контейнера: `mongo:7` и `redis:7`. Из контейнера `alpine` (в той же сети) проверь, что оба имени резолвятся: `getent hosts mongo`, `getent hosts redis`.

### Самопроверка
**Ответ:**

В custom bridge-сети работает встроенный DNS: `getent hosts mongo` возвращает IP (172.18.x.x). Имена контейнеров в одной сети — это и есть «hostname», по которому сервисы находят друг друга. В дефолтной `bridge` сети DNS по именам между контейнерами не работает (им можно обращаться по IP), поэтому для сервисов создают свою сеть.

---

## 12. Реестр образов и Docker Hub

**Теория.** Реестр — это сервис хранения образов. Публичный «склад по умолчанию» — Docker Hub (`docker.io`). Свой образ загружают в реестр через `docker push`, именуя его `<Логин>/<Имя>:<Тег>`. Существуют и приватные реестры (GHCR, GitLab Registry, собственный `registry:2`).

**Схема push/pull:**

```
   docker build -t yourname/app:v1 .
                │
                ▼
   ┌───────────────────────── Docker Hub ─────────────────────────┐
   │   yourname/app:v1   ←  отсюда любой сервер: docker pull     │
   └─────────────────────────────────────────────────────────────┘
                ▲
                │ docker push yourname/app:v1 (требует docker login)
   локальный образ yourname/app:v1
```

### Попробуй сам
```shell
docker login                        # данные аккаунта Docker Hub
docker tag my-hello yourname/my-hello:v1    # переименовать (тег)
docker push yourname/my-hello:v1    # загрузить в свой репозиторий

# на другом компьютере / сервере:
docker pull yourname/my-hello:v1
docker run --rm yourname/my-hello:v1

# приватный реестр на своей машине (для изучения):
docker run -d --name registry -p 5000:5000 registry:2
docker tag my-hello localhost:5000/my-hello:v1
docker push localhost:5000/my-hello:v1
docker pull localhost:5000/my-hello:v1
docker rm -f registry
```

### Задание

1. Зарегистрируйся на hub.docker.com, создай репозиторий, собери образ, `docker login`, `docker push` и с другого устройства (или после `docker rmi`) `docker pull` его обратно.

### Самопроверка
**Ответ:**

- Имя образа для Hub — `логин/имя:тег`; без логина в имени push в Hub не пройдёт.
- `docker tag` не копирует данные, а добавляет ссылку с новым именем.
- `localhost:5000/...` — схема для приватных реестров; адрес реестра всегда перед именем образа.
- Публикация приватных данных: образ может содержать секреты из `.env` — не пуши то, чего не хочешь открыть.

---

## 13. Docker Swarm кратко

**Теория.** Swarm — встроенный режим Docker для оркестрации: кластер из машин (manager-узлы + worker-узлы), на которых Docker разворачивает *сервисы* (запущенные реплики образа), обеспечивает масштабирование и восстановление. Это «облегчённый Kubernetes внутри самого Docker». Для продакшена чаще выбирают Kubernetes; Swarm хорош для простых задач прямо из коробки.

**Схема кластера:**

```
        ┌───────────────────── SWARM-кластер ──────────────────────┐
        │    manager (команды управления)                          │
        │   ┌──────────────────────────────────┐                   │
        │   │  docker swarm init               │                   │
        │   └───────┬──────────────┬───────────┘                   │
        │           │ manager/token │ worker/token                 │
        │           ▼              ▼                               │
        │   ┌─────────┐      ┌─────────┐   ┌─────────┐             │
        │   │ worker1 │      │ worker2 │   │ worker3 │             │
        │   │ ┌─────┐ │      │ ┌─────┐ │   │ ┌─────┐ │             │
        │   │ │задача│ │      │ │задача│ │   │ │задача│ │           │
        │   │ └─────┘ │      │ └─────┘ │   │ └─────┘ │ │           │
        │   └─────────┘      └─────────┘   └─────────┘             │
        └──────────────────────────────────────────────────────────┘
   один образ → docker service create --replicas N → N задач на узлах
```

### Попробуй сам
```shell
docker swarm init                     # сделать текущий узел manager-ом
docker node ls

docker service create --name web --replicas 3 -p 8080:80 --network ingress nginx
docker service ls
docker service ps web                 # какие задачи на каких узлах
curl http://localhost:8080
docker service scale web=5            # масштабировать
docker service rm web

docker swarm leave --force            # покинуть кластер (временный)
```

### Задание

1. Инициализируй swarm на одном узле, создай сервис из `nginx` с 3 репликами, убедись в балансировке (несколько `curl`), масштабируй до 5, удали сервис.

### Самопроверка
**Ответ:**

- `docker service create` — аналог «управляемого run»: кластер сам расставляет реплики по узлам и перезапускает упавшие задачи.
- `docker service ps web` показывает задачи и их состояние (Running, Shutdown, Failed…).
- Swarm даёт встроенный ingress-балансировщик: `-p 8080:80` реплицирует запросы на все реплики.
- `docker stack deploy -c compose.yaml my_app` деплоит Compose-файл поверх Swarm (поле `deploy:` в compose.yaml).

---

## 14. Многоступенчатые сборки

**Теория.** Multi-stage build — сборка в несколько «этапов» (`FROM … AS имя`). Промежуточный этап содержит весь инструментарий сборки (компилятор, npm…), а в финальный образ копируются только *готовые артефакты*. Итоговый образ на порядки меньше и безопаснее (нет компилятора и исходников).

**Схема:**

```
 ЭТАП 1: builder (большой)          ЭТАП 2: финальный (маленький)
┌─────────────────────────────┐    ┌──────────────────────────────┐
│ FROM golang:1.23 AS builder │    │ FROM alpine:latest           │
│ WORKDIR /app                │    │ WORKDIR /app                 │
│ COPY . .                    │    │ COPY --from=builder          │
│ RUN go build -o myapp       │────▶│      /app/myapp ./myapp     │
└─────────────────────────────┘    │ CMD ["./myapp"]              │
                                   └──────────────────────────────┘
   компилятор + исходники            только бинарник (~5 МБ vs ~1 ГБ)
   остаются «на промежуточном»       без инструментов сборки
```

### Попробуй сам

Папка `~/gostage`, файл `main.go`:
```go
package main

import "fmt"

func main() {
    fmt.Println("hello from multi-stage build")
}
```

`Dockerfile`:
```dockerfile
# Этап 1 — сборка
FROM golang:1.23-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o myapp . && chmod +x myapp

# Этап 2 — минимальный финальный образ
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/myapp ./myapp
USER 65534:65534     # никто (nobody)
CMD ["./myapp"]
```

Сборка и проверка размера:
```shell
mkdir -p ~/gostage && cd ~/gostage
# положи main.go и Dockerfile как выше
docker build -t my-go .
docker run --rm my-go            # → hello from multi-stage build
docker images                    # сравни размер образа ~7 МБ (без компилятора)
docker history my-go             # только нужные слои: base, copy, cmd
```

### Задание

1. Сравни размер `my-go` с размером, который получился бы при одноэтапной сборке `FROM golang:1.23-alpine` + `RUN go build`. Запиши выигрыш в мегабайтах.

2. Сделай multi-stage для Node.js: в этапе 1 — `npm ci` + `npm run build` (соберёт статику в `dist`), в этапе 2 — `nginx:alpine` и `COPY --from=builder /app/dist /usr/share/nginx/html`.

### Самопроверка
**Ответ:**

- Первый этап с `golang:1.23-alpine` весит сотни МБ, финальный из `alpine` с бинарником — единицы МБ.
- `COPY --from=builder …` берёт файл из другого этапа; этапы-«посредники» не попадают в итог.
- Node.js пример: этап builder ставит зависимости и строит статику, финальный — голый nginx с `dist`; статика отдаётся nginx-ом размером ~50 МБ вместо сотен МБ node-образа.

---

## 15. Безопасность Docker

**Теория.** Базовые правила безопасности контейнеров:

1. **Минимальные права** — процесс в контейнере запускается не от `root`, а от обычного пользователя (`USER`).
2. **Минимальные пакеты** — меньше кода в образе = меньше поверхности атаки.
3. **Никаких секретов в образе** — пароли, токены и ключи не попадают в Dockerfile и в слой. Передавай их через переменные окружения, `--env-file`, docker secrets, или монтируй чувствительные файлы.
4. **Актуальность** — базовые образы и зависимости обновлять; пиновать версии тегами, а не `latest`.
5. **Сканирование** — `docker scout` (встроен в Hub/CLI) и `trivy` находят уязвимости.
6. **Не подавай в контейнер лишнего** — `.dockerignore` исключает `.env`, `node_modules`, `.git`.

### Попробуй сам
```shell
docker scout quickview my-hello judge       # уязвимости (есть в CLI 26+)
trivy image my-hello                        # если установлен trivy

docker run --rm alpine true                 # процесс от root (по умолчанию)
docker run --rm --user 65534:65534 alpine whoami   # → nobody

# секреты через переменную окружения без попадания в образ:
docker run -e DB_PASS='s3cret' --rm alpine printenv DB_PASS
# секреты из файла:
echo 'DB_PASS=s3cret' > .env.nogit
docker run --env-file .env.nogit --rm alpine printenv DB_PASS
```

### Задание

1. Перепиши Dockerfile раздела 6 так, чтобы он: использовал `node:22-alpine`, не содержал секретов, переключался на пользователя `appuser`, скачивал зависимости до копирования кода. Проверь, что в `docker history` нет строк с паролями.

### Самопроверка
**Ответ:**

- `docker run --user 65534:65534` даёт контейнеру минимальные права (UID без хост-прав).
- Секреты в переменных окружения живут только в запуске (`-e` / `--env-file`) и не появляются в слоях образа.
- `docker history` покажет слои без секретов; строки с `ENV DB_PASS=…` — тревожный сигнал (секрет «зашит» в образ).
- Сканеры (`docker scout`, `trivy`) находят известные CVE в базовых образах — это первая линия защиты.

---

## 16. Оптимизация размера образа

**Теория.** Маленький образ = быстрее скачивание и запуск, меньше рисков. Приёмы:

1. **Минимальный базовый образ**: `alpine` (~5 МБ), `distroless`, или `scratch` для статических бинарников.
2. **Один `RUN`-блок на установку + очистка в нём же**:
   `RUN apt-get update && apt-get install -y --no-install-recommends pkg && rm -rf /var/lib/apt/lists/*`.
3. **Без кэш-файлов**: `npm ci --omit=dev`, `pip install --no-cache-dir`.
4. **Multi-stage build** (раздел 14) — финальный образ без инструментов сборки.
5. **`.dockerignore`** — не отправлять демону лишний контекст.
6. **Конкретные теги** вместо `latest` — предсказуемые и обновляемые версии.
7. **`--no-install-recommends` / `--no-cache`** для apt/apk: apk — `apk add --no-cache pkg`.

### Попробуй сам
```shell
docker images | grep -E 'alpine|debian|node|golang'
# типичные размеры:
#   alpine:latest         ~7 МБ
#   debian:bookworm-slim ~30 МБ
#   node:22-alpine       ~60 МБ
#   golang:1.23-alpine   ~270 МБ
```

Два варианта одного Dockerfile:

```dockerfile
# ПЛОХОЙ: три слоя и остатки
FROM debian:bookworm
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y vim
```

```dockerfile
# ХОРОШИЙ: один слой, чисто
FROM debian:bookworm-slim
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl \
 && rm -rf /var/lib/apt/lists/*
```

### Задание

1. Собери образ из «плохого» и из «хорошего» Dockerfile, сравни `docker images` по размеру. Затем добавь `.dockerignore`, игнорирующий `*.md`, `.git`, и проверь `docker build` вывод «context sent … » — его объём должен резко упасть.

### Самопроверка
**Ответ:**

- «Хороший» образ меньше: удаляются списки пакетов apt и лишние рекомендации; объединение в один `RUN` убирает промежуточные слои.
- `docker build` с `.dockerignore` показывает меньший размер контекста (например «11.05kB» вместо «1.2MB»).
- Разница особенно велика между `debian` (~120 МБ+) и `debian:bookworm-slim` (~30 МБ) или `alpine` (~7 МБ).

---

## 17. Проекты-практикумы

Пошаговые проекты, каждый опирается на разделы учебника. Делай их по порядку.

### Проект 1. Собственный веб-сервер с готовым контейнером

1. Установи Docker (раздел 2).
2. `docker run -d --name site -p 8080:80 nginx`.
3. Открой `http://localhost:8080` — работает «из коробки».
4. Замени контент через bind mount: `mkdir -p ~/site && echo '<h1>Мой сайт</h1>' > ~/site/index.html`, запусти `docker run -d -p 8081:80 -v ~/site:/usr/share/nginx/html:ro nginx`.
5. Посмотри логи (`docker logs site`) и процесс (`docker exec -it site bash`).

### Проект 2. Своё приложение в Python Flask + Dockerfile

1. Папка `~/flaskapp`, файл `app.py`:
```python
from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "<h1>Привет из Docker!</h1><p>Это моё Flask-приложение</p>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```
2. `requirements.txt`: `flask==3.0.3`.
3. `Dockerfile`:
```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]
```
4. `docker build -t flask-app .` и `docker run -d -p 5000:5000 flask-app`.
5. Открой `http://localhost:5000`.
6. Запусти такой же контейнер ещё раз с другим портом `5001` — два контейнера из одного образа работают параллельно.

### Проект 3. Веб + БД через Docker Compose (реальный мини-стек)

1. Возьми пример из раздела 9 (Express + PostgreSQL). Добавь сервис `redis` для кэша:
```yaml
  redis:
    image: redis:7-alpine
    restart: unless-stopped
```
2. Добавь в `web` `REDIS_URL: redis://redis:6379`.
3. `docker compose up -d --build`, проверь `docker compose ps`, останови `db` и посмотри, как приложение отдаёт `db down`.
4. Сделай `docker compose down -v` и убедись, что при повторном `up` база пустая. Затем подними «по-взрослому» с томом (как в разделе 10).

### Проект 4. Multi-stage сборка маленького Go-сервиса

1. Папка `~/gosvc`, `go.mod` (`module gosvc`, `go 1.23`), `main.go` с HTTP-сервером на `:8080`.
2. Dockerfile из раздела 14; финальный образ — `FROM gcr.io/distroless/static-debian12:nonroot` или `alpine` с `USER 65534`.
3. Собери, запусти, замерь размер (`docker images`) и убедись, что в образе нет Go-инструментов (`docker exec` искать нечего — их нет; проверь `/bin`).

### Проект 5. Приватный реестр и деплой образа на «сервер»

1. Подними собственный реестр: `docker run -d -p 5000:5000 --name registry registry:2`.
2. Собери `flask-app`, затегь `localhost:5000/flask-app:v1`, `docker push` → `docker rmi` → `docker pull` из «другого места».
3. Проверь хранение образов в реестре: `curl http://localhost:5000/v2/_catalog`.

### Проект 6. Swarm-стек с Compose (финальный)

1. `docker swarm init`.
2. Создай `stack.yaml` на основе compose-файла из Проекта 3, добавив поле `deploy.replicas: 3`.
3. `docker stack deploy -c stack.yaml mysite`.
4. Проверь `docker service ls`, масштаб `docker service scale mysite_web=5`, посмотри балансировку, удали `docker stack rm mysite`.

---

## 18. Практика и задания

### Задание 1. Установка и первый контейнер
Установите Docker (раздел 2), добавьте себя в группу `docker`. Выполните `docker run hello-world` и `docker --version`. Опишите, что вывел `hello-world`.

### Задание 2. Запуск веб-сервера с пробросом портов
Запустите nginx: `docker run -d --name my_nginx -p 8080:80 nginx:alpine`. Откройте в браузере `http://localhost:8080`. Проверьте `docker ps` и `docker port my_nginx`.

### Задание 3. Интерактивный контейнер и exec
Запустите `docker run -it ubuntu bash`, создайте файл `/tmp/check.txt`, выйдите (`Ctrl+D`). Теперь запустите `docker run -d --name busy alpine sleep 1000` и выполните внутри него команды через `docker exec -it busy sh` и `docker exec busy cat /etc/alpine-release`. Сравните окружение контейнера и хоста.

### Задание 4. Логи и ограничение ресурсов
Запустите контейнер, генерирующий логи (например `docker run -d --name spam busybox sh -c "while true; do echo log $(date); sleep 2; done"`). Просмотрите логи: `docker logs --tail 5 spam`, `docker logs -f spam` (выход — `Ctrl+C`). Создайте контейнер с лимитами `--memory=128m --cpus=0.5` и проверьте `docker stats`.

### Задание 5. Жизненный цикл контейнера
Создайте контейнер `my_nginx`. Поочерёдно: `stop`, `start`, `restart`, `pause`, `unpause`, `rm`. Проследите изменение статусов через `docker ps -a`. Удалите после.

### Задание 6. Образы и их очистка
Скачайте несколько образов (`alpine`, `ubuntu`, `nginx`, `redis`), посмотрите их размер через `docker images`. Удалите один образ `docker rmi`, потом очистите всё неиспользуемое `docker system prune -a`. Сравните `docker system df` до и после.

### Задание 7. Свой Dockerfile
Напишите Dockerfile для простого приложения (напишите сами статический сайт или возьмите пример из раздела 6). Соберите `docker build -t myapp .`, запустите с пробросом порта, проверьте `docker history myapp`. Добавьте `.dockerignore` и убедитесь, что лишние файлы не попадают в контекст.

### Задание 8. Многоступенчатая сборка
Возьмите пример Go/Node из раздела 14, соберите его и сравните размер итогового образа с размером, если бы вы просто взяли большой базовый образ.

### Задание 9. Тома и bind mount
Создайте том `pgdata` и запустите postgres с `-v pgdata:/var/lib/postgresql/data`. Создайте таблицу, затем удалите контейнер (`docker rm -f`). Запустите postgres заново с тем же томом и убедитесь, что данные сохранились. Затем то же самое с bind mount папки `$PWD/data`.

### Задание 10. Пользовательская сеть
Создайте сеть `app_net`. Запустите в ней `redis` и `alpine`. Из контейнера alpine проверьте доступ к `redis` **по имени** (`redis-cli ping` или `getent hosts redis`). Остановите контейнеры, попробуйте то же в дефолтной сети — сравните.

### Задание 11. Docker Compose: веб + база
Соберите проект из раздела 9 (Node.js + PostgreSQL): `docker compose up -d`, `docker compose ps`, `docker compose logs -f db`. Убедитесь, что web видит db по имени. Выполните `down`, затем `down -v` и посмотрите, что произошло с именованным томом.

### Задание 12. Healthcheck, инвентаризация и профилактика
Для compose-проекта из задания 11 задайте `healthcheck` сервису `db` (`pg_isready`) и `depends_on` у web с `condition: service_healthy`; сервису web добавьте собственный healthcheck. Проверьте статусы (Healthy/Unhealthy/Starting) в `docker compose ps`. Затем напишите shell-скрипт из раздела «docker inspect» для вывода IP-адресов всех контейнеров (добавьте имя и статус) и выполните `docker system df` с безопасной очисткой неиспользуемых контейнеров и висящих образов, не затрагивая важные тома.

---

## 19. Онлайн-тренажеры и ресурсы

Площадки для отработки навыков Docker:

| Ресурс | Описание |
| --- | --- |
| [Play with Docker](https://labs.play-with-docker.com/) | Бесплатная песочница Docker в браузере — запускайте контейнеры без установки. |
| [KodeKloud: Docker for Beginners](https://kodekloud.com/courses/docker-for-the-absolute-beginner/) | Интерактивный курс с лабораторными работами прямо в браузере. |
| [Docker Hub](https://hub.docker.com/) | Каталог готовых образов — можно запускать и экспериментировать. |
| [Docker Documentation](https://docs.docker.com/) | Официальная документация с примерами и руководствами. |
| [Exercism: Docker](https://exercism.org/tracks/bash) | Задачи по Bash, связанные с Docker. |
| [Shipyard](https://github.com/shipyard-run/shipyard) | Локальная среда для экспериментов с Docker Compose и Nomad. |

---

## 20. Литература и ссылки

Официальная документация:
- https://docs.docker.com/ — главный портал документации Docker
- https://docs.docker.com/engine/install/ — установка Docker Engine
- https://docs.docker.com/reference/cli/docker/ — справочник команд CLI
- https://docs.docker.com/reference/dockerfile/ — инструкции Dockerfile
- https://docs.docker.com/compose/ — Docker Compose (спецификация compose.yaml)
- https://docs.docker.com/storage/ — тома, bind mounts, tmpfs
- https://docs.docker.com/network/ — драйверы сетей
- https://docs.docker.com/get-started/ — учебник «Get started» для новичков
- https://docs.docker.com/reference/cli/docker/scout/ — сканирование образов (docker scout)

Полезные русскоязычные материалы:
- https://hub.docker.com/ — Docker Hub (регистрация и репозитории)
- https://habr.com/ru/search/?q=docker — обзоры и практики по Docker на Хабре
- https://techrocks.ru/ — статьи по Dockerfile и контейнерам (см. «Лучшие практики Dockerfile»)

Совет: не верь слепо гайдам — сверяй синтаксис команд с `docker <команда> --help` и официальными доками выше.
