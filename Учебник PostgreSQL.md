# PostgreSQL — интерактивный учебник-практикум для новичков

**PostgreSQL** — мощная объектно-реляционная система управления базами данных (СУБД), известная своей надёжностью, соответствием стандартам SQL и расширяемостью. В отличие от MySQL, PostgreSQL поддерживает транзакции на полном уровне, JSONB, оконные функции, геоданные и собственные расширения. Является выбором для аналитики, финтех-проектов и любых задач, где важна целостность данных.

> **Для кого:** прошёл (или параллельно проходит) учебник **SQL.md** в этой же папке.
> **Что понадобится:** Linux, где есть `apt-get` (ALT Linux, Debian, Ubuntu) и права root.
> **Версии:** материал актуален для PostgreSQL 16 и 17 (все примеры проверены на PostgreSQL 17).
> **Что внутри:** типы данных (включая JSONB/ARRAY/UUID), индексы и EXPLAIN ANALYZE, транзакции и уровни изоляции, оконные функции, CTE, представления и материализованные представления, PL/pgSQL, триггеры, JSON/JSONB, полнотекстовый поиск, резервное копирование, базовый тюнинг.

Каждый раздел: **теория → ASCII-схема → «Попробуй сам» → «Задание» → «Самопроверка»**. Все «Попробуй сам» можно выполнять в консоли `psql` на демо-базе из раздела «Демо-база».

---

## Содержание

- [Как устроен учебник](#как-устроен-учебник)
- [Чем PostgreSQL отличается от MySQL](#чем-postgresql-отличается-от-mysql)
- [Установка и запуск](#установка-и-запуск)
- [Работа с psql](#работа-с-psql)
- [Демо-база: интернет-магазин](#демо-база-интернет-магазин)
- [CREATE TABLE и типы данных](#create-table-и-типы-данных)
- [SERIAL и GENERATED: автоинкремент](#serial-и-generated-автоинкремент)
- [JSONB и ARRAY: встроенные структуры](#jsonb-и-array-встроенные-структуры)
- [UUID: универсальные идентификаторы](#uuid-универсальные-идентификаторы)
- [Индексы: CREATE INDEX и EXPLAIN ANALYZE](#индексы-create-index-и-explain-analyze)
- [Транзакции и уровни изоляции](#транзакции-и-уровни-изоляции)
- [Оконные функции подробнее](#оконные-функции-подробнее)
- [CTE: конструкция WITH](#cte-конструкция-with)
- [Представления: VIEW и материализованные](#представления-view-и-материализованные)
- [Функции и хранимые процедуры PL/pgSQL](#функции-и-хранимые-процедуры-plpgsql)
- [Триггеры](#триггеры)
- [Работа с JSON/JSONB](#работа-с-jsonjsonb)
- [Полнотекстовый поиск](#полнотекстовый-поиск)
- [Резервное копирование: pg_dump и pg_restore](#резервное-копирование-pg_dump-и-pg_restore)
- [Инструменты: pgAdmin и DBeaver](#инструменты-pgadmin-и-dbeaver)
- [Базовый тюнинг: EXPLAIN, vacuum, autovacuum](#базовый-тюнинг-explain-vacuum-autovacuum)
- [Практика: 20 заданий](#практика-20-заданий)
- [Проекты-практикумы](#проекты-практикумы)
- [Онлайн-тренажеры и ресурсы](#онлайн-тренажеры-и-ресурсы)
- [Литература и ссылки](#литература-и-ссылки)

---

## Как устроен учебник

- Сначала читаешь теорию (коротко, без воды).
- Смотришь схему — как это работает «глазами».
- Вставляешь блок «Попробуй сам» в консоль psql.
- Делаешь «Задание», сверяешься с «Самопроверкой» в разделе «Самопроверка».

Все примеры проверены на PostgreSQL 17.11. Для совместимости с 16-й версией ничего менять не нужно — используемые конструкции поддерживаются обеими.

---

## Чем PostgreSQL отличается от MySQL

Вот ключевые различия, которые чаще всего влияют на выбор. Сводная таблица по итогам сравнения двух СУБД:

| Критерий | PostgreSQL | MySQL |
| --- | --- | --- |
| Лицензия | Свободная, полностью открытый код | Открытая и платные версии (Oracle) |
| Следование стандарту SQL | Очень высокая (большинство пунктов стандарта) | Ниже — упор на скорость |
| Упор | Сложные запросы, большие БД, аналитика | Веб-проекты с интенсивным чтением |
| Целостность по ACID | Полная, встроенная MVCC | Волнительная; MVCC только в InnoDB |
| Расширяемость | Новые типы, функции, индесы | Ограниченная |
| Типы данных | JSONB, ARRAY, UUID, диапазоны | JSON, нет массивов |
| Работа с регистром строк | чувствителен | не чувствителен |
| Кавычки для строк | только одинарные | одиночные и двойные |
| Безопасность | роли (ROLE), встроенный SSL | ACL, ограниченный SSL |
| Репликация | логическая, потоковая, двунаправленная | master-slave, master-master |
| Языки программирования | почти все популярные | почти все популярные |

**Вывод простыми словами:**

- **MySQL** — быстро, просто, отлично для «читать побольше, быстро». Команды и синтаксис проще.
- **PostgreSQL** — мощнее: JSONB, массивы, сложные запросы, продвинутые индексы, функции. Дисциплинированнее следует стандарту SQL, а значит — проще переносить запросы между системами.

**Попробуй сам:**

```sql
-- Какая версия у тебя?
SHOW server_version;

-- Уровень изоляции по умолчанию (подробнее — в разделе про транзакции):
SHOW default_transaction_isolation;
```

**Задание:** определи по таблице: (а) в какой СУБД `WHERE city = 'Москва'` вернёт и строку с `'москва'`; (б) в какой удобнее хранить массив тегов у пользователя.

**Самопроверка:**

(а) В MySQL сравнение строк не чувствительно к регистру — вернёт и `'москва'`. В PostgreSQL строгие `= 'Москва'` не совпадёт с `'москва'` (поможет `ILIKE`).

(б) В PostgreSQL — есть встроенный тип `ARRAY` и `JSONB`. В MySQL пришлось бы делать отдельную таблицу тегов.

---

## Установка и запуск

### Подготовка: пользователь и кластер

PostgreSQL — серверная СУБД: она работает как служба (демон) и принимает соединения.

```bash
# Debian/Ubuntu/ALT-подобные:
sudo apt-get update && sudo apt-get install postgresql
sudo systemctl enable --now postgresql
sudo systemctl status postgresql
```

После установки в системе появляется системный пользователь `postgres` и локальный кластер баз данных. Суперпользователь СУБД по умолчанию — `postgres`, он же пользователь ОС.

### Первый вход

```bash
# зайти под суперпользователем (локально, через ОС):
sudo -u postgres psql

# внутри psql:
SELECT current_user, current_database();
\q
```

### Создание своей роли и базы

```sql
-- создаём роль (это и есть «пользователь»):
CREATE ROLE student LOGIN PASSWORD '123456';

-- создаём базу с владельцем:
CREATE DATABASE shop OWNER student;
```

Войти под своей ролью:

```bash
psql -h localhost -U student -d shop
# psql попросит пароль 123456
```

**Попробуй сам:**

```bash
# Проверка доступных баз (в консоли psql под суперпользователем):
\l

# Выход:
\q
```

> Если забыл пароль любой роли:
> ```sql
> ALTER ROLE student WITH PASSWORD 'новый';
> ```

**Задание:** создай роль `student` с паролем и базу `shop`, затем зайди в неё через `psql -h localhost -U student -d shop`.

**Самопроверка:**

```sql
CREATE ROLE student LOGIN PASSWORD '123456';
CREATE DATABASE shop OWNER student;
```

```bash
psql -h localhost -U student -d shop -c "SELECT current_user;"
```

В ответе должно быть `student`.

---

## Работа с psql

`psql` — это консольный клиент PostgreSQL. Он умеет и выполнять SQL, и управлять сервером через мета-команды (начинаются с `\`).

```
 ┌──────────┐    TCP/Unix-socket    ┌────────────────────┐    ┌───────────┐
 │  psql    │─────────────────────►│  Сервер PostgreSQL │───►│   БД shop │
 │ (клиент) │   host, port (5432)  │   postgres         │    │ таблицы,  │
 └──────────┘                      └────────────────────┘    │ индексы…  │
```

**Мета-команды, которые пригодятся каждый день:**

| Команда | Что делает |
| --- | --- |
| `\l` | список баз данных |
| `\dt` | список таблиц текущей базы |
| `\d users` | структура таблицы `users` (колонки, типы, ключи) |
| `\di` | список индексов |
| `\dv` | список представлений (views) |
| `\df` | список функций |
| `\x` | переключить вертикальный вывод строк |
| `\timing` | показывать время выполнения запросов |
| `\h SELECT` | справка по команде |
| `\?` | помощь по мета-командам |
| `\q` | выход |

**Попробуй сам:**

```bash
# в консоли psql:
\dt
\d users
\x
SELECT * FROM users WHERE id = 1;
\timing
SELECT count(*) FROM products;
\q
```

**Задание:** посмотри структуру таблиц из демо-базы (создадим её в следующем разделе) через `\d`, а затем выведи список индексов через `\di`.

**Самопроверка:**

Каждая таблица покажет свои колонки и типы. В списке индексов `\di` появятся индексы первичных ключей (`users_pkey`, `products_pkey`, `orders_pkey`, `order_items_pkey`) и уникальный индекс `users_email_key`.

---

## Демо-база: интернет-магазин

Как и в учебнике по SQL, практикуемся на интернет-магазине. Но теперь — с возможностями PostgreSQL: массивы, JSONB, автоинкремент `GENERATED`.

Скопируй скрипт в файл `shop.sql` и выполни:

```bash
psql -h localhost -U student -d shop -f shop.sql
```

```sql
-- ======== ДЕМО-БАЗА ДЛЯ PostgreSQL ========
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        TEXT NOT NULL,
    email       TEXT UNIQUE NOT NULL,
    age         INTEGER CHECK (age >= 18),
    city        TEXT,
    tags        TEXT[] DEFAULT '{}',
    preferences JSONB DEFAULT '{}'::jsonb,
    created_at  TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE products (
    id          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        TEXT NOT NULL,
    category    TEXT,
    price       NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock       INTEGER NOT NULL DEFAULT 0,
    attributes  JSONB DEFAULT '{}'::jsonb
);

CREATE TABLE orders (
    id          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id     INTEGER NOT NULL REFERENCES users(id),
    order_date  DATE NOT NULL,
    status      TEXT DEFAULT 'new'
);

CREATE TABLE order_items (
    order_id    INTEGER NOT NULL REFERENCES orders(id),
    product_id  INTEGER NOT NULL REFERENCES products(id),
    quantity    INTEGER NOT NULL CHECK (quantity > 0),
    price       NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (order_id, product_id)
);

INSERT INTO users (name, email, age, city, tags, preferences) VALUES
    ('Иванов Иван',    'ivanov@example.com',    25, 'Москва',        ARRAY['regular','vip'],   '{"notify": true,  "theme": "dark"}'::jsonb),
    ('Петрова Анна',   'petrova@example.com',   31, 'Санкт-Петербург', ARRAY['regular'],       '{"notify": false, "theme": "light"}'::jsonb),
    ('Сидоров Олег',   'sidorov@example.com',   19, 'Казань',        ARRAY['newbie'],          '{"notify": true}'::jsonb),
    ('Смирнова Мария', 'smirnova@example.com',  45, 'Москва',        ARRAY['vip','wholesale'], '{"theme": "dark"}'::jsonb),
    ('Козлов Дмитрий', 'kozlov@example.com',    27, 'Новосибирск',   ARRAY['regular'],         '{}'::jsonb),
    ('Новикова Елена', 'novikova@example.com',  23, 'Екатеринбург',  ARRAY['vip'],            '{"notify": true, "lang": "ru"}'::jsonb);

INSERT INTO products (name, category, price, stock, attributes) VALUES
    ('Ноутбук',         'Электроника', 59999.00, 12, '{"brand": "Lenovo",  "ram_gb": 16}'::jsonb),
    ('Смартфон',        'Электроника', 24999.00, 45, '{"brand": "Xiaomi",  "ram_gb": 8}'::jsonb),
    ('Наушники',        'Электроника',  3999.00, 80, '{"brand": "JBL",     "wireless": true}'::jsonb),
    ('Футболка',        'Одежда',        899.00, 200, '{"size": "L",   "color": "white"}'::jsonb),
    ('Джинсы',          'Одежда',       2599.00, 100, '{"size": "M",   "color": "blue"}'::jsonb),
    ('Куртка',          'Одежда',       7999.00, 30,  '{"size": "XL",  "color": "black"}'::jsonb),
    ('Кофеварка',       'Дом',         15999.00, 20,  '{"brand": "DeLonghi", "type": "espresso"}'::jsonb),
    ('Чайник',          'Дом',          2999.00, 60,  '{"brand": "Tefal",    "volume_l": 1.7}'::jsonb),
    ('Книга «SQL для всех»', 'Книги',   799.00, 150,  '{"author": "Иванов П."}'::jsonb),
    ('Настольная лампа', 'Дом',         1299.00, 25,  '{"led": true}'::jsonb);

INSERT INTO orders (user_id, order_date, status) VALUES
    (1, '2024-01-10', 'completed'),
    (1, '2024-02-14', 'completed'),
    (2, '2024-01-22', 'completed'),
    (3, '2024-03-01', 'pending'),
    (4, '2024-03-15', 'completed'),
    (5, '2024-03-18', 'cancelled'),
    (6, '2024-04-02', 'new'),
    (2, '2024-04-10', 'new'),
    (3, '2024-05-05', 'completed'),
    (4, '2024-05-20', 'pending');

INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
    (1, 1, 1, 59999.00),
    (1, 3, 1,  3999.00),
    (2, 4, 2,   899.00),
    (3, 2, 1, 24999.00),
    (4, 5, 1,  2599.00),
    (5, 7, 1, 15999.00),
    (5, 8, 2,  2999.00),
    (6, 9, 1,   799.00),
    (7, 3, 1,  3999.00),
    (8, 2, 2, 24999.00),
    (9, 6, 1,  7999.00),
    (9, 4, 3,   899.00),
    (10, 9, 5,  799.00);
```

### Схема базы

```
  users                          products
┌────────────┬───────┐          ┌────────────┬────────────┐
│ id         │ PK    │          │ id         │ PK         │
│ name       │       │          │ name       │            │
│ email      │ UNIQUE│          │ category   │            │
│ age        │       │          │ price      │            │
│ city       │       │          │ stock      │            │
│ tags       │ ARRAY │          │ attributes │ JSONB      │
│ preferences│ JSONB │          └─────┬──────┘
│ created_at │ timest│                │
└─────┬──────┘        ┌───────────────┤
      │ 1:N           │               │
      │          ┌────▼─────┐         │
      │          │  orders  │         │
      │          │ id PK    │         │
      └─────────►│ user_id FK│         │
                 │ order_date│         │
                 │ status    │         │
                 └────┬──────┘         │
                      │ 1:N           │ 1:N
                 ┌────▼───────────────▼──────┐
                 │        order_items        │  M:N через order_items
                 │ order_id FK · product_id FK│
                 │ quantity · price           │
                 └──────────────────────────┘
```

**Попробуй сам:**

```sql
-- Автоинкремент раздал id сам для users/products/orders:
SELECT 'users', count(*) FROM users
UNION ALL SELECT 'products', count(*) FROM products
UNION ALL SELECT 'orders', count(*) FROM orders;

-- Простая проверка выборо содержимого:
SELECT name, email, tags FROM users WHERE id = 6;
```

**Задание:** выполни скрипт и убедись, что после `INSERT` у таблиц `users`, `products`, `orders` есть строки (попробуй вставить строку с явным `id` — что произойдёт? Это ключевая мысль про `GENERATED ALWAYS`).

**Самопроверка:**

```sql
-- Попытка вставить явный id провалится:
INSERT INTO users (id, name, email) VALUES (100, 'Тест', 't@t.ru');
-- ERROR: cannot insert a non-DEFAULT value into column "id"
```

Колонка с `GENERATED ALWAYS AS IDENTITY` сама раздаёт значения. Об этом — следующий раздел.

---

## CREATE TABLE и типы данных

Базовые типы данных PostgreSQL (для новичка):

| Тип | Пример | Что хранит |
| --- | --- | --- |
| `INTEGER`, `BIGINT` | `42`, `1099511627776` | целые числа |
| `NUMERIC(10,2)` | `59999.00` | деньги/точные дроби (без потерь) |
| `DOUBLE PRECISION`, `REAL` | `3.14159265` | числа с плавающей точкой (округление) |
| `TEXT` | `'Книга'` | строка произвольной длины |
| `VARCHAR(n)` | `'email@example.com'` | строка до n символов |
| `BOOLEAN` | `true`, `false` | логика |
| `DATE` | `2024-01-10` | дата |
| `TIMESTAMPTZ` | `2024-01-10 12:30:00+03` | момент времени (с часовым поясом) |
| `UUID` | `a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11` | глобально уникальный идентификатор |
| `JSONB` | `{"theme":"dark"}` | JSON в бинарном виде |
| `ARRAY` | `{vip,regular}` | массив элементов |

**Особенность PostgreSQL:** типы строгие. `INSERT` с «чужим» значением отклоняется сервером.

**Попробуй сам:**

```sql
-- Посмотрим фактические типы нашей демо-базы:
\d users

-- Приведение типов: явное кастирование оператором ::
SELECT '42'::INTEGER + 1 AS sum_int;
SELECT now()::date AS today;
SELECT 59999.00::NUMERIC(10,2) AS price;

-- Дата/время: что вернёт now() и interval
SELECT now(), now() - interval '1 day' AS yesterday;
SELECT current_date, current_time;
```

**Задание:** создай тестовую таблицу `temp_bonus` с колонками `id INTEGER`, `score NUMERIC(5,2)`, `wins BOOLEAN`, `at TIMESTAMPTZ` и вставь одну строку, используя кастирование.

**Самопроверка:**

```sql
CREATE TABLE temp_bonus (
    id INTEGER,
    score NUMERIC(5,2),
    wins BOOLEAN,
    at TIMESTAMPTZ
);
INSERT INTO temp_bonus VALUES (1, 9.95, true, now());
SELECT * FROM temp_bonus;
DROP TABLE temp_bonus;
```

---

## SERIAL и GENERATED: автоинкремент

Есть два способа сделать «самовозрастающий» первичный ключ:

- **Устаревший `SERIAL`** (`SERIAL`, `BIGSERIAL`) — под капотом создаёт последовательность (sequence) и значение по умолчанию.
- **Стандартный `GENERATED ... AS IDENTITY`** — SQL-стандарт, современный способ. Именно он используется в демо-базе.

```sql
-- способ 1: SERIAL (исторический, никуда не денется)
CREATE TABLE t1 (id SERIAL PRIMARY KEY, s TEXT);

-- способ 2: GENERATED — рекомендуемый
CREATE TABLE t2 (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    s TEXT
);

-- посмотреть на свои последовательности можно так:
\ds
```

Разница: с `GENERATED ALWAYS` вставить явный `id` сервер запретит (мы это видели). Ключевая мысль для приложений — не передавать `id` в `INSERT` вовсе.

**Попробуй сам:**

```sql
-- Вставляем без id:
INSERT INTO t2 (s) VALUES ('первая'), ('вторая') RETURNING id, s;

-- RETURNING — удобная штука PostgreSQL: вернуть вставленные строки
INSERT INTO products (name, category, price, stock)
VALUES ('Микрофон', 'Электроника', 3499, 40)
RETURNING id, name, price;
```

**Задание:** создай таблицу `sequence_demo (id INTEGER GENERATED ALWAYS AS IDENTITY, v TEXT)`, вставь 3 строки и выведи выданные `id` через `RETURNING`.

**Самопроверка:**

```sql
CREATE TABLE sequence_demo (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    v TEXT
);
INSERT INTO sequence_demo (v) VALUES ('a'), ('b'), ('c') RETURNING id;
DROP TABLE sequence_demo;
```

Вернутся id 1, 2, 3.

---

## JSONB и ARRAY: встроенные структуры

### Массивы (`ARRAY`)

```sql
-- Литерал массива:
SELECT ARRAY['a', 'b', 'c'] AS arr;

-- Индекс с 1:
SELECT tags[1] AS first_tag FROM users WHERE id = 1;          -- 'regular'
SELECT tags[array_length(tags, 1)] AS last_tag FROM users WHERE id = 4;

-- Разворот массива в строки (unnest):
SELECT unnest(tags) AS tag FROM users WHERE id = 4;

-- Проверка «содержит элемент»:
SELECT name FROM users WHERE 'vip' = ANY(tags);
```

### JSONB

`JSONB` хранит JSON в разобранном (бинарном) виде: поиск и изменения быстрее, есть операторы.

**Операторы JSONB:**

| Оператор | Что делает |
| --- | --- |
| `-> 'ключ'` | значение ключа (как jsonb, с кавычками в выводе) |
| `->> 'ключ'` | значение ключа как текст (без кавычек) |
| `#> '{a,b}'` | путь вглубь (jsonb) |
| `#>> '{a,b}'` | путь вглубь (текст) |
| `@>` | «содержит» (левое содержит правое) |
| `? 'ключ'` | есть ли ключ |
| `||` | объединение двух jsonb |

**Попробуй сам:**

```sql
-- Достаём значения
SELECT name, preferences->'theme' AS theme_json,
             preferences->>'lang' AS lang_text
FROM users;

-- Поиск по содержимому: у кого notify = true?
SELECT name FROM users WHERE preferences @> '{"notify": true}';

-- У каких товаров есть бренд?
SELECT name, attributes->>'brand' AS brand
FROM products WHERE attributes ? 'brand';

-- Собираем JSON на лету
SELECT jsonb_build_object('name', name, 'price', price) FROM products WHERE id = 1;

-- Красивый вывод
SELECT jsonb_pretty(preferences) FROM users WHERE id = 6;
```

**Задание:** выведи список пользователей, у которых тег `vip`, вместе с их «языком» из настроек, если он есть.

**Самопроверка:**

```sql
SELECT name, preferences->>'lang' AS lang
FROM users
WHERE 'vip' = ANY(tags);
```

Вернутся: Иванов Иван (lang NULL), Смирнова Мария (NULL), Новикова Елена (ru).

---

## UUID: универсальные идентификаторы

`UUID` — 128-битный идентификатор с практически нулевой вероятностью коллизии. Удобен, когда id должны быть уникальными без центрального счётчика (распределённые системы, синхронизация между базами).

```sql
-- Генерация прямо в запросе (встроено начиная с PostgreSQL 13):
SELECT gen_random_uuid();

-- Создание таблицы с UUID-ключом:
CREATE TABLE sessions (
    token    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id  INTEGER REFERENCES users(id),
    opened_at TIMESTAMPTZ DEFAULT now()
);

INSERT INTO sessions (user_id) VALUES (1), (2) RETURNING token;

-- Посмотреть:
DROP TABLE sessions;
```

**Сравнение с INTEGER:** `INTEGER` быстрее сортируется и занимает 4-8 байт, `UUID` занимает 16 байт. Для внутренних ключей чаще используют `BIGINT/GENERATED`; `UUID` — когда идентификатор должен быть видимым клиенту и не угадываемым.

**Попробуй сам:**

```sql
SELECT gen_random_uuid() AS u1, gen_random_uuid() AS u2;
```

**Задание:** создай таблицу `api_keys (id UUID DEFAULT gen_random_uuid() PRIMARY KEY, label TEXT)`, вставь 2 строки и покажи выданные ключи через `RETURNING`.

**Самопроверка:**

```sql
CREATE TABLE api_keys (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    label TEXT
);
INSERT INTO api_keys (label) VALUES ('web'), ('mobile') RETURNING id;
DROP TABLE api_keys;
```

Каждый раз будут разные UUID.

---

## Индексы: CREATE INDEX и EXPLAIN ANALYZE

Индекс ускоряет поиск, порядок сортировки, уникальность и JOIN — ценой места на диске и чуть более медленных INSERT/UPDATE/DELETE.

```
 Без индекса (Seq Scan):                 С индексом (Index Scan):
 ┌────────────────────┐                 ┌────────────────────┐
 │ сканируем КАЖДУЮ    │                 │ B-дерево           │
 │ строку таблицы      │                 │ ┌─────┐            │
 │ 1.000.000 проверок  │                 │ │ ... │ ← спуск    │
 └────────────────────┘                 │ └──┬──┘            │
                                        │    ▼               │
                                        │ ┌─────────────────┐│
                                        │ │ лист: значение+ ││
                                        │ │ указатель на    ││
                                        │ │ строку          ││
                                        │ └─────────────────┘│
                                        │ затем одна загрузка│
                                        │ строки             │
                                        └────────────────────┘
```

**EXPLAIN ANALYZE** показывает, как сервер реально выполнил запрос: способ доступа (Seq Scan / Index Scan / Bitmap Heap Scan), оценки стоимости и фактическое время.

**Попробуй сам:**

```sql
-- Создаём индексы
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_attrs ON products USING gin(attributes);

-- Смотрим план до и после (на маленькой таблице сервер может выбрать Seq Scan — это нормально):
EXPLAIN ANALYZE SELECT * FROM products WHERE category = 'Электроника';

-- Чтобы продемонстрировать Index Scan насильно (только для учебной демонстрации!):
SET enable_seqscan = off;
EXPLAIN ANALYZE SELECT * FROM products WHERE category = 'Электроника';
EXPLAIN ANALYZE SELECT * FROM products WHERE attributes @> '{"brand": "Xiaomi"}';
RESET enable_seqscan;
```

Ты увидишь примерно такое:

```
 Index Scan using idx_products_category on products
   (cost=0.14..8.15 rows=1 width=120)
   (actual time=0.018..0.018 rows=3 loops=1)
   Index Cond: (category = 'Электроника'::text)
 Planning Time: 0.082 ms
 Execution Time: 0.026 ms
```

Для JSONB-условия сервер построит `Bitmap Index Scan` по GIN-индексу.

**Задание:** объясни, почему для условия `WHERE attributes @> '{"brand":"Xiaomi"}'` подходит именно GIN-индекс, а не обычный B-tree.

**Самопроверка:**

Обычный B-tree индексирует поточные сравнения (`=`, `<`), а `@>` — это поиск по содержимому JSONB (пересечение множеств). GIN (generalized inverted index) строит индекс по каждому вложенному значению и умеет такие запросы. Для полноценной демонстрации полезен пример с большим числом строк — на 190 строках сервер честно предпочитает Seq Scan.

---

## Транзакции и уровни изоляции

Транзакции в PostgreSQL те же, что и в учебнике по SQL: `BEGIN` … `COMMIT` / `ROLLBACK`. Но у PostgreSQL есть богатые настройки параллелизма.

**Уровни изоляции** (по возрастанию строгости):

| Уровень | Аномалии, которые остаются |
| --- | --- |
| `READ UNCOMMITTED` | фактически недоступен — сервер ведёт его как `READ COMMITTED` |
| `READ COMMITTED` (по умолчанию) | non-repeatable read (№1) и phantom (№2) |
| `REPEATABLE READ` | только phantom (№2) |
| `SERIALIZABLE` | полная изоляция: ни одна из аномалий |

**Три классические аномалии:**

```
 1. Dirty read (грязное чтение) — транзакция B видит данные,
    которые A ещё НЕ закоммитила (и может откатить).

    A: BEGIN; UPDATE ... val=200; ──► B читает val=200 (грязно!)
    A: ROLLBACK;                   B видела несуществующее состояние.

 2. Non-repeatable read (неповторяемое чтение) — внутри одной
    транзакции одно и то же значение меняется.

    A: BEGIN; SELECT val → 100
       ─── другая транзакция COMMITила val=200 ───
       A: SELECT val → 200          ← результат «поплыл»

 3. Phantom read (фантомы) — при повторном SELECT появляются новые строки.
    A: BEGIN; SELECT count(*) → 10
       ─── другая транзакция вставила строку и COMMIT ───
       A: SELECT count(*) → 11      ← «фантом»
```

**Попробуй сам (один терминал, автоматизировано):**

Создай табличку для эксперимента:

```sql
CREATE TABLE iso_demo (id int PRIMARY KEY, val int);
INSERT INTO iso_demo VALUES (1, 100);
```

Теперь **READ COMMITTED** — второй `SELECT` увидит 200 (non-repeatable read):

```sql
-- блок A (начни его первым)
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT val AS first_read FROM iso_demo WHERE id = 1;
SELECT pg_sleep(4);              -- даём галочку другой транзакции
SELECT val AS second_read FROM iso_demo WHERE id = 1;
COMMIT;
```

```sql
-- блок B (выполни в течение этих 4 секунд)
UPDATE iso_demo SET val = 200 WHERE id = 1;
COMMIT;
```

Порядок запуска: блок A в одном терминале, сразу блок B во втором. Результат A: `first_read = 100`, `second_read = 200`.

Теперь **REPEATABLE READ** — второй `SELECT` снова вернёт 100:

```sql
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT val AS first_read FROM iso_demo WHERE id = 1;
SELECT pg_sleep(4);
SELECT val AS second_read FROM iso_demo WHERE id = 1;
COMMIT;
```

```sql
UPDATE iso_demo SET val = 300 WHERE id = 1;
COMMIT;
```

Результат A: `first_read = 100`, `second_read = 100` — снимок зафиксирован на начало транзакции.

> Совет: если выполняешь руками в двух окнах — просто запусти блок A, затем блок B, затем дождись завершения A.

**Задание:** объясни, какая аномалия «вылечена» переходом от `READ COMMITTED` к `REPEATABLE READ`, и какая остаётся (почему `REPEATABLE READ` ещё не `SERIALIZABLE`).

**Самопроверка:**

`REPEATABLE READ` «вылечивает» non-repeatable read и dirty read. Остаётся **phantom read**: другая транзакция может вставить новые строки, и при повторном запросе по диапазону они появятся. Полную защиту даёт только `SERIALIZABLE` (она реализована через отслеживание конфликтующих записей).

---

## Оконные функции подробнее

Напомним принцип (из SQL-учебника): оконная функция вычисляет значение **для каждой строки**, сохраняя все строки результата.

```
 ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY order_date)
┌────┬─────────┬────────────┬───────────┐
│ id │ user_id │ order_date │  rn       │
│ 1  │ 1       │ 2024-01-10 │    1      │
│ 2  │ 1       │ 2024-02-14 │    2      │   окно user_id=1
│ 3  │ 2       │ 2024-01-22 │    1      │
│ 8  │ 2       │ 2024-04-10 │    2      │   окно user_id=2
└────┴─────────┴────────────┴───────────┘
```

**Семейство оконных функций PostgreSQL:**

- `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()` — нумерация и рейтинги.
- `NTILE(n)` — разбиение строк окна на n одинаковых корзин.
- `LAG(кол, offset)` / `LEAD(кол, offset)` — значение из предыдущей/следующей строки.
- `FIRST_VALUE` / `LAST_VALUE` — первое/последнее значение окна.
- `SUM(...) OVER (...)`, `AVG`, `COUNT`, `MIN`, `MAX` — накопительные/скользящие агрегаты.
- Ranges и frams: `ROWS BETWEEN ... AND ...` — контроль «скользящего окна».

**Попробуй сам:**

```sql
-- LAG/LEAD: предыдущий и следующий заказ
SELECT id, order_date,
       LAG(order_date)  OVER (ORDER BY order_date) AS prev,
       LEAD(order_date) OVER (ORDER BY order_date) AS next,
       NTILE(4)         OVER (ORDER BY order_date) AS quartile
FROM orders
ORDER BY order_date;

-- Накопительная стоимость заказов по дате
SELECT o.id, o.order_date,
       SUM(oi.quantity * oi.price) OVER (ORDER BY o.order_date, o.id) AS running_total
FROM orders o JOIN order_items oi ON oi.order_id = o.id;

-- Ранги в рейтинге товаров категории
SELECT name, category, price,
       ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) AS pos,
       RANK()       OVER (PARTITION BY category ORDER BY price DESC) AS rk
FROM products
ORDER BY category, price DESC;

-- Скользящее окно: сумма по «текущей и двум предыдущим» строкам
-- (ROWS BETWEEN ... PRECEDING AND CURRENT ROW = границы окна)
WITH series AS (
    SELECT generate_series(1, 6) AS n
)
SELECT n,
       SUM(n) OVER (ORDER BY n ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_sum
FROM series;
```

Результат: `1, 3, 6, 9, 12, 15` — начиная с 4-й строки в окно попадают ровно «две предыдущие + текущая».

> В демо-базе для «скользящих» витрин удобнее группировать заказы по месяцам (см. ниже CTE и материализованные представления).

**Задание:** выведи для каждого заказа номер «по порядку» внутри пользователя и дату предыдущего заказа этого же пользователя (помоги себе: `PARTITION BY user_id`).

**Самопроверка:**

```sql
SELECT id, user_id, order_date,
       ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY order_date) AS nth,
       LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_date
FROM orders
ORDER BY user_id, order_date;
```

---

## CTE: конструкция WITH

**CTE (Common Table Expression)** — именованный подзапрос в начале запроса: `WITH имя AS (SELECT ...) SELECT ...`. Код становится читаемым, подзапрос переиспользуется, а специальный случай — **рекурсивные CTE**.

```
WITH weekly AS (
    SELECT ... FROM orders GROUP BY week ...
)
SELECT * FROM weekly WHERE total > X;
```

**Попробуй сам:**

```sql
-- Шаг 1: подсчёт трат по пользователям
WITH totals AS (
    SELECT o.user_id, SUM(oi.quantity * oi.price) AS total
    FROM orders o JOIN order_items oi ON oi.order_id = o.id
    GROUP BY o.user_id
)
SELECT u.name, t.total,
       RANK() OVER (ORDER BY t.total DESC) AS pos
FROM users u JOIN totals t ON t.user_id = u.id;

-- Шаг 2: только топ-3
WITH totals AS (
    SELECT o.user_id, SUM(oi.quantity * oi.price) AS total
    FROM orders o JOIN order_items oi ON oi.order_id = o.id
    GROUP BY o.user_id
)
SELECT u.name, t.total
FROM users u JOIN totals t ON t.user_id = u.id
ORDER BY t.total DESC LIMIT 3;
```

**Рекурсивный CTE — генерим ряд чисел:**

```sql
WITH RECURSIVE nums AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM nums WHERE n < 5
)
SELECT * FROM nums;
```

**Задание:** с помощью CTE построй месячный отчёт продаж: для каждого месяца 2024 года — количество заказов и выручку (подсказка: `date_trunc('month', order_date)`).

**Самопроверка:**

```sql
WITH monthly AS (
    SELECT date_trunc('month', o.order_date)::date AS month,
           COUNT(DISTINCT o.id) AS orders_cnt,
           SUM(oi.quantity * oi.price) AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.id
    GROUP BY 1
)
SELECT * FROM monthly ORDER BY month;
```

---

## Представления: VIEW и материализованные

**Обычное представление (VIEW)** — сохранённый SELECT; данных не хранит, выполняет запрос при каждом обращении.

**Материализованное представление (MATERIALIZED VIEW)** — «замороженный» результат запроса, хранится на диске как таблица. Читается очень быстро, но устаревает: обновляется командой `REFRESH MATERIALIZED VIEW`.

```
 VIEW: каждый SELECT  ──►  запрос выполняется заново
        (всегда свежие данные; медленнее)

 MATERIALIZED VIEW:  хранит СНИМОК результата
        REFRESH MATERIALIZED VIEW → новый снимок
        (данные могут устареть; чтение мгновенно)
```

**Попробуй сам:**

```sql
-- Простое представление
CREATE OR REPLACE VIEW v_order_value AS
SELECT o.id, u.name, SUM(oi.quantity * oi.price) AS total
FROM orders o
JOIN users u ON u.id = o.user_id
JOIN order_items oi ON oi.order_id = o.id
GROUP BY o.id, u.name;

SELECT * FROM v_order_value ORDER BY total DESC LIMIT 3;

-- Материализованное: месячная статистика
CREATE MATERIALIZED VIEW mv_orders_by_month AS
SELECT date_trunc('month', order_date)::date AS month, COUNT(*) AS orders
FROM orders
GROUP BY 1;

SELECT * FROM mv_orders_by_month ORDER BY month;

-- После изменения данных «замороженный» снимок надо обновить:
REFRESH MATERIALIZED VIEW mv_orders_by_month;

-- Удаление: обычное и материализованное
DROP VIEW v_order_value;
DROP MATERIALIZED VIEW mv_orders_by_month;
```

**Задание:** объясни простыми словами, когда выгодно использовать MATERIALIZED VIEW вместо обычного, и почему его называют «снимком».

**Самопроверка:**

MATERIALIZED VIEW выгоден для **тяжёлых, редко меняющихся** агрегатов: большая отчётность, статистика по миллионам строк. Её считают раз в час/сутки, а потом читают мгновенно. Обычное VIEW всегда свежее, но каждый раз пересчитывается заново.

---

## Функции и хранимые процедуры PL/pgSQL

**PL/pgSQL** — встроенный процедурный язык PostgreSQL. На нём пишут функции и процедуры, которые живут в базе.

Разница понятий:

- **Функция** возвращает значение и может использоваться в SELECT (`RETURNS ...`).
- **Процедура** не возвращает значение, вызывается через `CALL` (появились в SQL-стандарте).

Функции и процедуры оборачиваются в блок `$$ ... $$` — это «доллар-кавычки» (не дают путаницы с обычными кавычками внутри).

**Попробуй сам (функция):**

```sql
CREATE OR REPLACE FUNCTION add_stock(pid INT, delta INT) RETURNS INT AS $$
BEGIN
    UPDATE products SET stock = stock + delta WHERE id = pid;
    RETURN (SELECT stock FROM products WHERE id = pid);
END;
$$ LANGUAGE plpgsql;

SELECT add_stock(1, 5);     -- 17 (был 12)
SELECT add_stock(1, -5);    -- вернём как было, чтобы не портить демо
```

**Попробуй сам (процедура):**

```sql
CREATE OR REPLACE PROCEDURE delete_cancelled() AS $$
BEGIN
    -- сначала удаляем позиции заказов, потом сами заказы
    DELETE FROM order_items oi USING orders o
     WHERE oi.order_id = o.id AND o.status = 'cancelled';
    DELETE FROM orders WHERE status = 'cancelled';
END;
$$ LANGUAGE plpgsql;

CALL delete_cancelled();
SELECT count(*) FROM orders WHERE status = 'cancelled';   -- 0
```

> Обрати внимание: процедура сама управляет порядком удаления (сначала `order_items`, потом `orders`), чтобы не упасть на ограничениях внешнего ключа.

**Задание:** создай функцию `avg_price(cat TEXT)` с параметром-категорией, возвращающую среднюю цену товаров этой категории, и вызови её.

**Самопроверка:**

```sql
CREATE OR REPLACE FUNCTION avg_price(cat TEXT) RETURNS NUMERIC AS $$
BEGIN
    RETURN (SELECT AVG(price) FROM products WHERE category = cat);
END;
$$ LANGUAGE plpgsql;

SELECT avg_price('Электроника');   -- 29665.67
```

---

## Триггеры

**Триггер** — функция/процедура, которая автоматически выполняется при событии (`INSERT`, `UPDATE`, `DELETE`, `TRUNCATE`) на таблице.

```
  INSERT INTO orders ...
         │
         ▼
  ┌───────────────────────────┐
  │  BEFORE INSERT / AFTER …  │
  │  FOR EACH ROW             │
  │  выполняет функцию log()  │
  └───────────────────────────┘
         │
         ▼
  изменения применяются
```

Типы событий на таблице:

- `BEFORE` / `AFTER` — до или после срабатывания команды;
- `FOR EACH ROW` — для каждой строки; `FOR EACH STATEMENT` — один раз на команду;
- `INSTEAD OF` — на представлениях.

**Попробуй сам:**

```sql
-- Журнал действий над заказами
CREATE TABLE order_log (
    id SERIAL PRIMARY KEY,
    order_id INT,
    action TEXT,
    logged_at TIMESTAMPTZ DEFAULT now()
);

-- Функция-обработчик
CREATE OR REPLACE FUNCTION log_order() RETURNS trigger AS $$
BEGIN
    INSERT INTO order_log (order_id, action) VALUES (NEW.id, TG_OP);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер: логируем каждую вставку
CREATE TRIGGER trg_log
BEFORE INSERT ON orders
FOR EACH ROW EXECUTE FUNCTION log_order();

-- Проверяем
INSERT INTO orders (user_id, order_date, status) VALUES (1, '2024-06-01', 'new');
SELECT action, order_id FROM order_log;   -- INSERT, 11

-- Убираем временные объекты (чтобы не мешали практике)
DROP TRIGGER trg_log ON orders;
DROP TABLE order_log;
```

> `NEW` — новая строка, `OLD` — старая (при UPDATE/DELETE). `TG_OP` — название операции.

**Задание:** вставь в продажу проверку: функция-триггер, которая запрещает уменьшать остаток ниже нуля (поднять исключение при `NEW.stock < 0`).

**Самопроверка:**

```sql
CREATE OR REPLACE FUNCTION check_stock() RETURNS trigger AS $$
BEGIN
    IF NEW.stock < 0 THEN
        RAISE EXCEPTION 'Остаток не может быть отрицательным: %', NEW.stock;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_stock BEFORE UPDATE ON products
FOR EACH ROW EXECUTE FUNCTION check_stock();

UPDATE products SET stock = -5 WHERE id = 1;   -- ERROR
DROP TRIGGER trg_stock ON products;
DROP FUNCTION check_stock();
```

---

## Работа с JSON/JSONB

PostgreSQL умеет и `JSON` (текстовый), и `JSONB` (бинарный). На практике почти всегда выбирают `JSONB`: его индексируют, по нему ищут операторами, он быстрее. `JSON` нужен, когда важно сохранить порядок ключей и точный исходный текст.

**Попробуй сам:**

```sql
-- Извлечение по ключу
SELECT name, preferences->'theme' AS theme
FROM users WHERE id = 1;

-- Извлечение как текст
SELECT preferences->>'lang' AS lang FROM users WHERE id = 6;

-- Поиск по содержимому: у кого тёмная тема?
SELECT name FROM users WHERE preferences @> '{"theme": "dark"}';

-- Наличие ключа
SELECT name FROM users WHERE preferences ? 'notify';

-- Обновление поля внутри JSONB
UPDATE users
SET preferences = preferences || '{"theme": "light"}'::jsonb
WHERE id = 1;
SELECT name, preferences FROM users WHERE id = 1;

-- Вернём обратно
UPDATE users
SET preferences = preferences || '{"theme": "dark"}'::jsonb
WHERE id = 1;
```

**Построение и разбор JSON:**

```sql
-- Собрать массив с объектом
SELECT jsonb_build_object('name', name, 'email', email) FROM users WHERE id = 2;

-- Развернуть массив jsonb в строки
SELECT * FROM jsonb_array_elements('[1,2,3]'::jsonb);

-- Красиво напечатать
SELECT jsonb_pretty('{"a": {"b": [1,2,3]}}'::jsonb);
```

**Задание:** составь список товаров (id, название, бренд) как JSON-массив для категории «Электроника» — с помощью `jsonb_agg` и `jsonb_build_object`.

**Самопроверка:**

```sql
SELECT jsonb_agg(jsonb_build_object(
    'id', id,
    'name', name,
    'brand', attributes->>'brand'
))
FROM products
WHERE category = 'Электроника';
```

---

## Полнотекстовый поиск

PostgreSQL умеет искать текст **по словам с учётом словоформ** (морфология русского языка): «наушник» найдёт и «наушники». Работает это так:

```
 текст ──► to_tsvector('russian', text)  →  лексемы
 запрос ─► to_tsquery / plainto_tsquery  →  лексемы
                     │
                     ▼  оператор @@ (совпадение)
                 результат: true/false + ранг (ts_rank)
```

**Попробуй сам:**

```sql
-- tsvector: как текст превращается в лексемы
SELECT to_tsvector('russian', 'Книга «SQL для всех» для начинающих');

-- tsquery: запрос
SELECT plainto_tsquery('russian', 'начинающий');

-- Совпадение с учётом словоформ
SELECT to_tsvector('russian', 'Наушники новые JBL')
       @@ plainto_tsquery('russian', 'наушник') AS matches;   -- t

-- Поиск по демо-базе
CREATE INDEX idx_products_fts
    ON products USING gin(to_tsvector('russian', name));

SELECT name FROM products
WHERE to_tsvector('russian', name) @@ to_tsquery('russian', 'Книга');

-- Ранжирование результатов
SELECT name,
       ts_rank(to_tsvector('russian', name),
               plainto_tsquery('russian', 'книга')) AS rank
FROM products
ORDER BY rank DESC LIMIT 3;
```

**Задание:** переведи отчётливый пример в демо-форму: найди через полнотекстовый поиск товар с лексемой «наушник», затем с «упаковка» (ожидай: первый — есть, второй — нет).

**Самопроверка:**

```sql
SELECT name FROM products
WHERE to_tsvector('russian', name) @@ to_tsquery('russian', 'наушник');
-- Найдёт «Наушники»

SELECT name FROM products
WHERE to_tsvector('russian', name) @@ to_tsquery('russian', 'упаковка');
-- Пусто: такого слова в названиях нет
```

---

## Резервное копирование: pg_dump и pg_restore

**pg_dump** создаёт логический дамп базы — файл с SQL-командами или архив. **pg_restore** восстанавливает из архива.

```
 ┌──────────┐   pg_dump -Fc shop > shop.dump   ┌──────────┐
 │   база   │ ───────────────────────────────► │shop.dump │
 │   shop   │                                  └──────────┘
 └──────────┘                                     │
                                                 │ pg_restore
                                                 ▼
 ┌──────────┐   pg_restore -d shop_new shop.dump ┌──────────┐
 │ shop_new │ ◄──────────────────────────────────│ (файл)   │
 └──────────┘                                    └──────────┘
```

Форматы:

- **plain** (`-f shop.sql`, по умолчанию) — текст с SQL; восстанавливается через `psql`.
- **custom** (`-Fc`) — сжатый архив; восстановление через `pg_restore`, можно выборочное.
- **directory** (`-Fd`) — архив-каталог (можно распараллелить).

**Попробуй сам (в терминале ОС, не в psql):**

```bash
# текстовый дамп:
pg_dump -U student -d shop -f shop.sql

# сжатый архив:
pg_dump -U student -Fc -d shop -f shop.dump

# восстановление в новую базу:
createdb -U student shop_restore
psql -U student -d shop_restore -f shop.sql          # для plain
pg_restore -U student -d shop_restore shop.dump      # для -Fc

# удалить тестовую базу:
dropdb -U student shop_restore
```

**Задание:** сделай резервную копию базы `shop`, удали из неё тестовую строку (например, заказ), восстанови базу и убедись, что строка вернулась.

**Самопроверка:**

```bash
pg_dump -U student -d shop -Fc -f /tmp/shop.dump
psql -U student -d shop -c "DELETE FROM order_items WHERE order_id=1; DELETE FROM orders WHERE id=1;"
createdb -U student shop_restore
pg_restore -U student -d shop_restore /tmp/shop.dump
psql -U student -d shop_restore -t -c "SELECT count(*) FROM orders;"   # снова 10
dropdb -U student shop_restore
```

---

## Инструменты: pgAdmin и DBeaver

После командной строки удобно переходить к графическим инструментам:

### pgAdmin 4

Официальный клиент PostgreSQL. Умеет: визуальный constructor запросов, кнопку EXPLAIN, просмотр и редактирование данных, деревья таблиц/индексов/представлений, бэкапы.

```bash
# Debian/Ubuntu/ALT:
sudo apt-get install pgadmin4
```

После запуска добавь сервер: host `localhost`, port `5432`, роль `student`, пароль — и увидишь свою базу `shop` в дереве объектов.

### DBeaver

Универсальный клиент (PostgreSQL, MySQL, SQLite и др.) от сообщества:

```bash
sudo apt-get install dbeaver
```

В DBeaver новый коннекшн тоже простой: PostgreSQL → host, port, db, user, password. Поддерживает SQL-консоль, просмотр ER-диаграммы схемы, экспорт данных.

**Задание:** подключись к `shop` в любом из клиентов и открой дерево: база → схемы → `public` → таблицы. Покликай таблицу `users` — появится вкладка с данными.

**Самопроверка:**

В дереве объектов: раздел «Таблицы» покажет `order_items`, `orders`, `products`, `users`. Окно данных позволит увидеть строки, а кнопка/панель Query Text — выполнить любой запрос из этого учебника.

---

## Базовый тюнинг: EXPLAIN, vacuum, autovacuum

### Читаем планы

Главный инструмент диагностики медленных запросов — `EXPLAIN ANALYZE`.

**Попробуй сам:**

```sql
-- Полный план с реальным выполнением
EXPLAIN ANALYZE
SELECT u.name, SUM(oi.quantity * oi.price) AS spent
FROM users u
JOIN orders o ON o.user_id = u.id
JOIN order_items oi ON oi.order_id = o.id
GROUP BY u.name
ORDER BY spent DESC;
```

Читаем блоки плана:

```
 Sort  (cost=... rows=...)                 ← сортировка
   └─ HashAggregate                       ← GROUP BY
        └─ Nested Loop / Hash Join        ← JOINи
             └─ Seq Scan / Index Scan     ← откуда берём
```

На что смотреть: **Seq Scan**, `actual time`, `rows` (совпадает ли с ожиданием планировщика), отсутствие индексов при фильтрах по неиндексированным колонкам.

### Vacuum и autovacuum

PostgreSQL хранит версии строк (MVCC). После UPDATE/DELETE старые версии превращаются в «мёртвые» строки. **VACUUM** чистит их; **ANALYZE** обновляет статистику для планировщика.

```
 UPDATE строки 10 и 20
   ──────────────────────────►  старые версии = "мёртвые"

 фоновый процесс autovacuum:
   └─► VACUUM  → убирает мёртвые версии строк
   └─► ANALYZE → пересчитывает статистику для планировщика
```

Автоматический **autovacuum** включён по умолчанию и обычно справляется сам. Задачи админа:

- следить за «bloated» таблицами (`VACUUM FULL` для дефрагментации, редко);
- после массовых правок запускать `ANALYZE`.

**Попробуй сам:**

```sql
-- Ручной вакуум (+анализ статистики)
VACUUM (ANALYZE);

-- Только анализ
ANALYZE users;

-- Показать, где включён autovacuum
SHOW autovacuum;
SHOW autovacuum_vacuum_threshold;

-- Статистику по таблице анализом
SELECT relname, n_live_tup, n_dead_tup, last_vacuum, last_autovacuum
FROM pg_stat_user_tables
WHERE relname IN ('users', 'products', 'orders');
```

**Задание:** выполни `VACUUM (ANALYZE)` и объясни разницу между `VACUUM`, `VACUUM FULL` и `ANALYZE`.

**Самопроверка:**

- `VACUUM` — обычная очистка мёртвых строк (не блокирует базу надолго, не уменьшает файл).
- `VACUUM FULL` — физическая компакция файла (блокирует таблицу, файл становится меньше).
- `ANALYZE` — только статистика для планировщика, данные не трогает.

---

## Практика: 20 заданий

Все задачи — на демо-базе `shop`. Для каждой: сначала подумай, потом выполни, потом сверься.

**1.** Выведи всех пользователей старше 30 лет.
**Ответ:**
```sql
SELECT name, age FROM users WHERE age > 30;
```

**2.** Найди заказы за февраль и март 2024 года.
**Ответ:**
```sql
SELECT * FROM orders WHERE order_date BETWEEN '2024-02-01' AND '2024-03-31';
```

**3.** Самый дорогой и самый дешёвый товар (двумя запросами или одним с подзапросами).
**Ответ:**
```sql
SELECT name FROM products ORDER BY price DESC LIMIT 1;
SELECT name FROM products ORDER BY price ASC  LIMIT 1;
```

**4.** Сколько товаров в категории «Дом»?
**Ответ:**
```sql
SELECT COUNT(*) FROM products WHERE category = 'Дом';
```

**5.** Средняя цена товаров по категориям.
**Ответ:**
```sql
SELECT category, AVG(price) FROM products GROUP BY category;
```

**6.** Пользователи, у которых больше одного заказа.
**Ответ:**
```sql
SELECT user_id FROM orders GROUP BY user_id HAVING COUNT(*) > 1;
```

**7.** Список всех заказов с именем покупателя.
**Ответ:**
```sql
SELECT o.id, u.name, o.order_date FROM orders o JOIN users u ON u.id = o.user_id;
```

**8.** Товары, которые никогда не продавались (LEFT JOIN).
**Ответ:**
```sql
SELECT p.name FROM products p LEFT JOIN order_items oi ON oi.product_id = p.id
WHERE oi.product_id IS NULL;
```

**9.** Товары, которые никогда не продавались (NOT EXISTS).
**Ответ:**
```sql
SELECT name FROM products p
WHERE NOT EXISTS (SELECT 1 FROM order_items oi WHERE oi.product_id = p.id);
```

**10.** Выручка по каждому заказу (сумма quantity × price).
**Ответ:**
```sql
SELECT order_id, SUM(quantity * price) AS total
FROM order_items GROUP BY order_id;
```

**11.** Топ-3 пользователя по сумме трат (JOIN + GROUP BY + ORDER + LIMIT).
**Ответ:**
```sql
SELECT u.name, SUM(oi.quantity * oi.price) AS spent
FROM users u
JOIN orders o ON o.user_id = u.id
JOIN order_items oi ON oi.order_id = o.id
GROUP BY u.name
ORDER BY spent DESC
LIMIT 3;
```

**12.** Номер заказа по порядку внутри пользователя (оконная функция).
**Ответ:**
```sql
SELECT id, user_id, order_date,
       ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY order_date) AS rn
FROM orders;
```

**13.** Ранг товаров внутри категории по цене (RANK + PARTITION).
**Ответ:**
```sql
SELECT name, category, price,
       RANK() OVER (PARTITION BY category ORDER BY price DESC) AS rk
FROM products;
```

**14.** Заказы, где сумма больше средней по всем заказам (подзапрос).
**Ответ:**
```sql
-- Шаг 1 (подзапрос в HAVING):
SELECT order_id, SUM(quantity * price) AS total
FROM order_items
GROUP BY order_id
HAVING SUM(quantity * price) > (
    SELECT AVG(total) FROM (
        SELECT SUM(quantity * price) AS total
        FROM order_items GROUP BY order_id
    ) x
);

-- Шаг 2 (то же через CTE, читается лучше):
WITH per_order AS (
    SELECT order_id, SUM(quantity * price) AS total
    FROM order_items GROUP BY order_id
)
SELECT * FROM per_order WHERE total > (SELECT AVG(total) FROM per_order);
```

**15.** Количество заказов по статусам (GROUP BY статус).
**Ответ:**
```sql
SELECT status, COUNT(*) FROM orders GROUP BY status;
```

**16.** Пользователи с тегом vip.
**Ответ:**
```sql
SELECT name FROM users WHERE 'vip' = ANY(tags);
```

**17.** Пользователи с уведомлениями из preferences (JSONB @>).
**Ответ:**
```sql
SELECT name FROM users WHERE preferences @> '{"notify": true}';
```

**18.** Последний заказ каждого пользователя (с вместо даты/или через оконную MAX).
**Ответ:**
```sql
SELECT DISTINCT ON (user_id) user_id, id, order_date
FROM orders
ORDER BY user_id, order_date DESC;
-- либо оконный вариант с ROW_NUMBER
```

**19.** Создай представление «выполненные заказы с суммой» и выбери из него топ-5.
**Ответ:**
```sql
CREATE VIEW v_done AS
SELECT o.id, u.name, SUM(oi.quantity * oi.price) AS total
FROM orders o JOIN users u ON u.id = o.user_id
JOIN order_items oi ON oi.order_id = o.id
WHERE o.status = 'completed'
GROUP BY o.id, u.name;
SELECT * FROM v_done ORDER BY total DESC LIMIT 5;
```

**20.** Материализуй месячную сводку выручки и обнови её.
**Ответ:**
```sql
CREATE MATERIALIZED VIEW mv_rev_month AS
SELECT date_trunc('month', o.order_date)::date AS month,
       SUM(oi.quantity * oi.price) AS revenue
FROM orders o JOIN order_items oi ON oi.order_id = o.id
GROUP BY 1;
SELECT * FROM mv_rev_month ORDER BY month;
REFRESH MATERIALIZED VIEW mv_rev_month;
```

**21.** Рекурсивный CTE: ряд чисел от 1 до 7.
**Ответ:**
```sql
WITH RECURSIVE nums AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM nums WHERE n < 7
)
SELECT * FROM nums;
```

**22.** Триггер, который логирует удаление заказов.
**Ответ:**
```sql
CREATE TABLE order_log (id SERIAL PRIMARY KEY, order_id INT, action TEXT);
CREATE FUNCTION log_del() RETURNS trigger AS $$
BEGIN INSERT INTO order_log (order_id, action) VALUES (OLD.id, TG_OP); RETURN OLD; END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_del BEFORE DELETE ON orders FOR EACH ROW EXECUTE FUNCTION log_del();
-- затем удали строку и проверь order_log
```

---

## Проекты-практикумы

### Проект 1. Отчёт «Анализ клиентской базы»

Напиши один запрос (можно с CTE), который вернёт по каждому пользователю:

- имя;
- количество заказов;
- выручку;
- средний чек;
- ранг по выручке.

Выведи топ-5. Сверься с «Самопроверкой», но сначала попробуй сам.

**Самопроверка (вариант):**

```sql
WITH stats AS (
    SELECT u.id, u.name,
           COUNT(DISTINCT o.id) AS orders_cnt,
           SUM(oi.quantity * oi.price) AS revenue
    FROM users u
    LEFT JOIN orders o ON o.user_id = u.id
    LEFT JOIN order_items oi ON oi.order_id = o.id
    GROUP BY u.id, u.name
)
SELECT name, orders_cnt, revenue,
       ROUND(revenue / NULLIF(orders_cnt, 0), 2) AS avg_check,
       RANK() OVER (ORDER BY revenue DESC NULLS LAST) AS pos
FROM stats
ORDER BY pos LIMIT 5;
```

### Проект 2. «Коэффициент удержания» — простая версия

Для каждого месяца выведи: сколько новых пользователей зарегистрировалось (по `created_at`) и сколько заказов пришлось на этот же месяц. Подсказка: `date_trunc('month', ...)` и два разных `GROUP BY`, соединённые по месяцу.

**Самопроверка (вариант):**

```sql
WITH regs AS (
    SELECT date_trunc('month', created_at)::date AS month, COUNT(*) AS new_users
    FROM users GROUP BY 1
),
sales AS (
    SELECT date_trunc('month', order_date)::date AS month, COUNT(*) AS orders
    FROM orders GROUP BY 1
)
SELECT COALESCE(r.month, s.month) AS month,
       COALESCE(new_users, 0) AS new_users,
       COALESCE(orders, 0) AS orders
FROM regs r FULL JOIN sales s ON s.month = r.month
ORDER BY month;
```

### Проект 3. «Товарные корзины»

Выведи пары товаров, которые чаще всего лежат в одном заказе (ассоциативные правила простейшего вида). Подсказка: self-join `order_items` на `order_items` по `order_id` с условием `product_id < product_id`.

**Самопроверка (вариант):**

```sql
SELECT a.product_id AS p1, b.product_id AS p2, COUNT(*) AS together
FROM order_items a
JOIN order_items b ON a.order_id = b.order_id AND a.product_id < b.product_id
GROUP BY a.product_id, b.product_id
ORDER BY together DESC;
```

### Проект 4. «Свой отчёт»

Придумай свою аналитику и упакуй её в MATERIALIZED VIEW. Идеи:

- доля «выполненных» заказов по пользователям (воронка статусов);
- самые щедрые покупатели месяца;
- товары, у которых цена ниже средней по категории, но они продаются.

Финальный шаг: оформи результат в виде README-текста 3-4 строки, чтобы можно было показать его коллеге.

---

## Онлайн-тренажеры и ресурсы

Площадки для отработки навыков PostgreSQL:

| Ресурс | Описание |
| --- | --- |
| PostgreSQL Tutorial — https://www.postgresqltutorial.com/ | Интерактивный учебник по PostgreSQL с примерами запросов. |
| SQL Murder Mystery — https://mystery.knightlab.com/ | Murder-mystery игра для изучения SQL — найдите убийцу с помощью запросов. |
| Exercism: SQL — https://exercism.org/tracks/sql | Задачи по SQL на Exercism с менторской проверкой. |
| HackerRank: SQL — https://www.hackerrank.com/domains/sql | Раздел «SQL» в тренажёре HackerRank — запросы разной сложности. |
| PostgreSQL Exercises — https://pgexercises.com/ | Упражнения по PostgreSQL — от основ до продвинутых запросов. |
| SQL-Academy — https://sql-academy.org/ru | Интерактивный онлайн-курс по SQL на русском языке. |
| pgAdmin — https://www.pgadmin.org/ | GUI-инструмент для работы с PostgreSQL. |

---

## Литература и ссылки

- Официальная документация PostgreSQL (англ.): https://www.postgresql.org/docs/
- PostgreSQL на русском (Postgres Professional): https://postgrespro.ru/docs
- Документация по psql: https://www.postgresql.org/docs/current/app-psql.html
- pgAdmin: https://www.pgadmin.org/
- DBeaver: https://dbeaver.io/
- Стандарт SQL кратко: https://www.sql-tutorial.ru/
- Сравнение PostgreSQL и MySQL (источник): https://wiki.merionet.ru/articles/podrobnoe-sravnenie-postgresql-i-mysql

> Соседний учебник: **SQL.md** — основы SQL и реляционной модели на SQLite.