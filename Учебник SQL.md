# SQL — интерактивный учебник-практикум для новичков

**SQL** (Structured Query Language) — язык запросов для работы с реляционными базами данных. С помощью SQL вы создаёте таблицы, добавляете, изменяете и удаляете данные, ищете информацию по условиям, объединяете данные из разных таблиц. SQL — один из самых востребованных навыков для аналитиков, разработчиков и администраторов баз данных.

> **Для кого:** те, кто впервые сталкивается с базами данных. Никакого опыта не требуется.
> **Что понадобится:** компьютер и 20 минут свободного времени для установки SQLite (раздел «Установка»).
> **Главный принцип учебника:** читаешь чуть-чуть теории → смотришь схему → сразу выполняешь запрос в терминале → делаешь маленькое задание → проверяешь себя.

Формат каждого раздела: **теория → ASCII-схема → «Попробуй сам» → «Задание» → «Самопроверка»**.
Все запросы из блоков «Попробуй сам» проверены и работают на демо-базе интернет-магазина. Просто копируй и вставляй в консоль SQLite.

---

## Содержание

- [Как устроен учебник](#как-устроен-учебник)
- [Демо-база: интернет-магазин](#демо-база-интернет-магазин)
- [Что такое БД и СУБД](#что-такое-бд-и-субд)
- [Реляционная модель](#реляционная-модель)
- [Типы данных](#типы-данных)
- [Установка: SQLite для практики, MySQL/PostgreSQL](#установка-sqlite-для-практики-mysqlpostgresql)
- [Первый запрос: SELECT](#первый-запрос-select)
- [Фильтрация: WHERE](#фильтрация-where)
- [Сортировка: ORDER BY](#сортировка-order-by)
- [LIMIT и OFFSET](#limit-и-offset)
- [Уникальные значения: DISTINCT](#уникальные-значения-distinct)
- [Агрегации: COUNT, SUM, AVG, MIN, MAX](#агрегации-count-sum-avg-min-max)
- [Группировка: GROUP BY и HAVING](#группировка-group-by-и-having)
- [JOIN: соединяем таблицы](#join-соединяем-таблицы)
- [INNER, LEFT, RIGHT, FULL, CROSS](#inner-left-right-full-cross)
- [Self-join: таблица сама с собой](#self-join-таблица-сама-с-собой)
- [Подзапросы, EXISTS, IN](#подзапросы-exists-in)
- [Подзапросы или JOIN?](#подзапросы-или-join)
- [UNION: складываем результаты](#union-складываем-результаты)
- [CASE: условия в запросах](#case-условия-в-запросах)
- [Строковые функции](#строковые-функции)
- [Работа с датами](#работа-с-датами)
- [Работа с NULL](#работа-с-null)
- [Индексы: ускоряем запросы](#индексы-ускоряем-запросы)
- [Транзакции и ACID](#транзакции-и-acid)
- [DML: INSERT, UPDATE, DELETE](#dml-insert-update-delete)
- [DDL и ограничения (constraints)](#ddl-и-ограничения-constraints)
- [Нормализация: 1НФ, 2НФ, 3НФ](#нормализация-1нф-2нф-3нф)
- [VIEW: виртуальные таблицы](#view-виртуальные-таблицы)
- [Оконные функции: ROW_NUMBER, RANK, OVER](#оконные-функции-row_number-rank-over)
- [Проекты-практикумы](#проекты-практикумы)
- [Дополнительные задания (PostgreSQL)](#дополнительные-задания-postgresql)
- [MySQL и PostgreSQL: краткое сравнение](#mysql-и-postgresql-краткое-сравнение)
- [Литература и ссылки](#литература-и-ссылки)

---

## Как устроен учебник

Каждый раздел состоит из четырёх частей:

1. **Теория** — короткий текст простыми словами.
2. **Схема** — рисунок из ASCII-символов, чтобы понять суть глазами.
3. **Попробуй сам** — готовый SQL-блок. Скопируй в консоль и выполни. Все блоки проверены на демо-базе из следующего раздела.
4. **Задание и Самопроверка** — маленькая задача и спрятанный ответ в разделе «Самопроверка».

### Быстрый старт (30 секунд)

```bash
# SQLite уже установлен в большинстве Linux-дистрибутивов.
# Проверь:
sqlite3 --version

# Создай рабочую папку и запусти тестовую базу «в памяти»:
sqlite3
```

### Стиль написания SQL

- Команды обычно пишут **ЗАГЛАВНЫМИ** буквами, таблицы и колонки — строчными. Так принято, но не обязательно.
- Каждая команда заканчивается точкой с запятой `;`.
- Строковые значения всегда в **одинарных** кавычках: `'Москва'`.
- Комментарии начинаются с `--`.

---

## Демо-база: интернет-магазин

Вся практика в этом учебнике построена на маленьком интернет-магазине из четырёх таблиц:

### Схема базы

```
┌────────────────────┐        ┌────────────────────┐
│       users        │        │      products      │
│────────────────────│        │────────────────────│
│ id (PK)            │        │ id (PK)            │
│ name               │        │ name               │
│ email (UNIQUE)     │        │ category           │
│ age                │        │ price              │
│ city               │        │ stock              │
│ created_at         │        └────────────────────┘
└────────┬───────────┘
         │  1 ────── N     ┌────────────────────┐
         │  (один          │       orders       │
         │   пользователь  │────────────────────│
         │   много         │ id (PK)            │
         │   заказов)      │ user_id (FK) ──────┤
         │                 │ order_date         │
         │                 │ status             │
         │                 └────────┬───────────┘
         │                          │  1 ──── N
         │                 ┌────────▼───────────┐
         │                 │    order_items     │   связующая
         │                 │────────────────────│   таблица для
         │                 │ order_id (FK)      │   связи M:N
         │                 │ product_id (FK)    │   товаров
         └────────────────►│ quantity           │   и заказов
                     order_items.product_id ────┼──► products.id
                           └────────────────────┘
```

### Создай базу

Скопируй весь скрипт ниже в файл `shop.sql`, затем выполни:

```bash
sqlite3 shop.db < shop.sql
```

```sql
-- ======== СОЗДАНИЕ ТАБЛИЦ ========
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id          INTEGER PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) UNIQUE NOT NULL,
    age         INTEGER CHECK (age >= 18),
    city        VARCHAR(50),
    created_at  DATE DEFAULT CURRENT_DATE
);

CREATE TABLE products (
    id          INTEGER PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    category    VARCHAR(50),
    price       NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock       INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE orders (
    id          INTEGER PRIMARY KEY,
    user_id     INTEGER NOT NULL REFERENCES users(id),
    order_date  DATE NOT NULL,
    status      VARCHAR(20) DEFAULT 'new'
);

CREATE TABLE order_items (
    order_id    INTEGER NOT NULL REFERENCES orders(id),
    product_id  INTEGER NOT NULL REFERENCES products(id),
    quantity    INTEGER NOT NULL CHECK (quantity > 0),
    price       NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (order_id, product_id)
);

-- ======== ДЕМО-ДАННЫЕ ========
INSERT INTO users (id, name, email, age, city, created_at) VALUES
    (1, 'Иванов Иван',    'ivanov@example.com',    25, 'Москва',      '2023-01-15'),
    (2, 'Петрова Анна',   'petrova@example.com',   31, 'Санкт-Петербург', '2023-02-20'),
    (3, 'Сидоров Олег',   'sidorov@example.com',   19, 'Казань',      '2023-03-10'),
    (4, 'Смирнова Мария', 'smirnova@example.com',  45, 'Москва',      '2023-04-05'),
    (5, 'Козлов Дмитрий', 'kozlov@example.com',    27, 'Новосибирск', '2023-05-12'),
    (6, 'Новикова Елена', 'novikova@example.com',  23, 'Екатеринбург', '2023-06-30');

INSERT INTO products (id, name, category, price, stock) VALUES
    (1, 'Ноутбук',        'Электроника',  59999.00, 12),
    (2, 'Смартфон',       'Электроника',  24999.00, 45),
    (3, 'Наушники',       'Электроника',   3999.00, 80),
    (4, 'Футболка',       'Одежда',         899.00, 200),
    (5, 'Джинсы',         'Одежда',        2599.00, 100),
    (6, 'Куртка',         'Одежда',        7999.00, 30),
    (7, 'Кофеварка',      'Дом',          15999.00, 20),
    (8, 'Чайник',         'Дом',           2999.00, 60),
    (9, 'Книга «SQL для всех»', 'Книги',   799.00, 150),
    (10, 'Настольная лампа',   'Дом',      1299.00, 25);

INSERT INTO orders (id, user_id, order_date, status) VALUES
    (1,  1, '2024-01-10', 'completed'),
    (2,  1, '2024-02-14', 'completed'),
    (3,  2, '2024-01-22', 'completed'),
    (4,  3, '2024-03-01', 'pending'),
    (5,  4, '2024-03-15', 'completed'),
    (6,  5, '2024-03-18', 'cancelled'),
    (7,  6, '2024-04-02', 'new'),
    (8,  2, '2024-04-10', 'new'),
    (9,  3, '2024-05-05', 'completed'),
    (10, 4, '2024-05-20', 'pending');

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

### Как открыть базу

```bash
# открыть базу и писать запросы в интерактивной консоли:
sqlite3 shop.db

# внутри консоли всё очень просто:
sqlite> .tables          -- список таблиц
sqlite> .schema users    -- показать структуру таблицы
sqlite> SELECT COUNT(*) FROM products;   -- любой SQL-запрос
sqlite> .quit            -- выйти
```

**Попробуй сам:**

```sql
-- Проверка: сколько пользователей, товаров, заказов?
SELECT 'пользователей', COUNT(*) FROM users
UNION ALL
SELECT 'товаров', COUNT(*) FROM products
UNION ALL
SELECT 'заказов', COUNT(*) FROM orders;
```

> Кстати: этот скрипт одинаково работает и в SQLite, и в PostgreSQL, и в MySQL — специально написан на «портативном» SQL.

**Задание:** создай базу, открой её и выведи все города из таблицы `users` одной колонкой.

**Самопроверка:**

```sql
SELECT city FROM users;
```

Должно получиться 6 строк: Москва, Санкт-Петербург, Казань, Москва, Новосибирск, Екатеринбург. Порядок строк в Query без `ORDER BY` не гарантирован — это нормально.

---

## Что такое БД и СУБД

**База данных (БД)** — это просто набор связанных данных (файлы на диске). **СУБД** — система управления базами данных — программа, которая этими файлами управляет: сохраняет, ищет, меняет, защищает.

SQL — язык, на котором приложение разговаривает с СУБД.

```
    Приложение (например, веб-сайт)
              │
              │  SQL-запрос: SELECT ...
              ▼
   ┌────────────────────┐
   │         СУБД       │   SQLite, PostgreSQL, MySQL
   │  (программа-сервер)│
   │  - принимает запрос │
   │  - планирует и      │
   │    выполняет его    │
   └─────────┬──────────┘
             │ читает/пишет
             ▼
   ┌────────────────────┐
   │    Файлы БД        │   на диске: .db, .sqlite,
   │  (данные + индексы)│   табличные пространства
   └────────────────────┘
```

Популярные СУБД:

| СУБД | Когда выбирать |
| --- | --- |
| **SQLite** | Учебник, маленькие проекты, мобильные приложения. Это файл-библиотека, сервер не нужен. |
| **PostgreSQL** | Сложные запросы, большие данные, строгое следование стандарту SQL. |
| **MySQL / MariaDB** | Классический выбор веб-проектов, быстрое чтение, простота. |

**Попробуй сам:**

```sql
-- Узнай, какая у тебя SQLite:
SELECT sqlite_version() AS version;
```

**Задание:** попробуй открыть базу `shop.db` текстовой командой `file shop.db` (в терминале Linux) и посмотри, что это за файл на самом деле.

**Самопроверка:**

SQLite хранит всю базу в одном обычном файле. `file shop.db` сообщит что-то вроде `SQLite 3.x database`. Именно поэтому SQLite так легко осваивать: базу можно скопировать на флешку.

---

## Реляционная модель

Реляционная СУБД хранит данные в **таблицах**. Таблица = строки (**records / tuple**) и колонки (**columns / атрибуты**). «Реляционная» — потому что таблицы **связаны** между собой.

```
 ТАБЛИЦА users
┌────┬──────────────┬─────────────────────┬─────┬────────┬────────────┐
│ id │ name         │ email               │ age │ city   │ created_at │  ← строка заголовка
├────┼──────────────┼─────────────────────┼─────┼────────┼────────────┤  (это не данные)
│ 1  │ Иванов Иван  │ ivanov@example.com  │ 25  │ Москва │ 2023-01-15 │  ← строка (запись)
│ 2  │ Петрова Анна │ petrova@example.com │ 31  │ СПб    │ 2023-02-20 │  ← строка
└────┴──────────────┴─────────────────────┴─────┴────────┴────────────┘
   ↑        ↑                ↑              ↑
   колонка  колонка          колонка        колонка
```

### Ключи

- **Первичный ключ (Primary Key, PK)** — колонка (или набор колонок), однозначно определяющая строку. Не может повторяться и не может быть пустой. В нашем примере это `id`.
- **Внешний ключ (Foreign Key, FK)** — колонка, которая ссылается на первичный ключ другой таблицы. Именно внешние ключи создают связи.

```
 Таблица orders                     Таблица users
┌────┬─────────┬──────┐             ┌────┬──────────────┐
│ id │ user_id │      │             │ id │ name         │
├────┼─────────┼──────┤  user_id    ├────┼──────────────┤
│ 1  │    1    ├──────┼────────────►│ 1  │ Иванов Иван  │
│ 2  │    1    │      │             │ 2  │ Петрова Анна │
│ 3  │    2    │      │             └────┴──────────────┘
└────┴─────────┴──────┘
    FK ────────► PK
```

### Виды связей

**1:1 (один к одному)** — каждой строке А соответствует максимум одна строка Б.

```
 users                     passports (внешний ключ = PK)
┌────┬──────────┐         ┌────┬─────────┬────────┐
│ id │ name     │         │ id │ user_id │ series │ ← user_id UNIQUE + PK
├────┼──────────┤   1:1   ├────┼─────────┼────────┤
│ 1  │ Иванов   ├─────────│ 1  │   1     │ 4000 1│
└────┴──────────┘         └────┴─────────┴────────┘
```

**1:N (один ко многим)** — у одного пользователя много заказов (уже видели выше).

```
 users                       orders
┌────┬──────────┐           ┌────┬─────────┐
│ 1  │ Иванов   │──┬──►     │ 1  │    1    │
│    │          │  └──►     │ 2  │    1    │  у одного
│    │          │           │ 3  │    2    │  user_id=1
└────┴──────────┘           └────┴─────────┘  два заказа
```

**N:M (многие ко многим)** — товар входит во многие заказы, заказ содержит много товаров. Реализуется **через промежуточную таблицу** `order_items`.

```
 products            order_items (связующая)        orders
┌────┬──────────┐   ┌──────────┬───────────┐   ┌────┬────────┐
│ 1  │ Ноутбук  │◄──│ product_id│ order_id  │──►│ 1  │ ...    │
│ 2  │ Смартфон │◄──│    1     │     1     │   │ 2  │ ...    │
└────┴──────────┘   │    2     │     3     │   └────┴────────┘
                    │    1     │     2     │
                    └──────────┴───────────┘
                    каждый товар ↔ каждый заказ
```

**Попробуй сам:**

```sql
-- Посмотри структуру таблиц (в консоли SQLite):
.schema users
.schema order_items

-- А это обычный запрос «свяжи пользователя с его заказом»:
SELECT users.name, orders.id AS order_no
FROM users
JOIN orders ON orders.user_id = users.id
WHERE users.id = 1;
```

### Группы SQL-команд

SQL делится на несколько групп команд:

| Группа | Назначение | Команды |
| --- | --- | --- |
| **DDL** | Определение структуры БД | `CREATE`, `ALTER`, `DROP`, `TRUNCATE` |
| **DML** | Манипуляция данными | `SELECT`, `INSERT`, `UPDATE`, `DELETE` |
| **DCL** | Управление доступом | `GRANT`, `REVOKE` |
| **TCL** | Транзакции | `COMMIT`, `ROLLBACK`, `SAVEPOINT` |

**Задание:** определи типы связей: (а) `users` и `order_items`; (б) `orders` и `products`.

**Самопроверка:**

(а) Внешние ключи есть у обеих таблиц через `orders` → это связь **1:N** (один пользователь — много позиций в заказах). Так как у `order_items` нет `user_id`, связь идёт транзитивно: `users → orders → order_items`.

(б) `orders` и `products` — типичная **N:M**: один заказ содержит много товаров, один товар есть во многих заказах. Промежуточная таблица — `order_items`, где `(order_id, product_id)` — составной первичный ключ.

---

## Типы данных

| Категория | SQLite | PostgreSQL / MySQL (похожие) | Что хранит |
| --- | --- | --- | --- |
| Целые | `INTEGER` | `INT`, `BIGINT`, `SERIAL` | числа без запятой: 25, −7 |
| Дробные | `REAL` | `NUMERIC(10,2)`, `DECIMAL`, `DOUBLE` | числа с запятой: 59999.00 |
| Строки | `TEXT` | `VARCHAR(50)`, `TEXT` | текст, e-mail, названия |
| Дата | `DATE` (как строка) | `DATE`, `TIMESTAMP` | дата `2024-01-10` |
| Логика | `INTEGER 0/1` | `BOOLEAN`, `BOOL` | истина/ложь |
| Двоичные | `BLOB` | `BYTEA` | картинки, файлы |
| Специальные | — | `JSONB`, `ARRAY`, `UUID` | см. учебник по PostgreSQL |

**Важная особенность SQLite:** типы там «гибкие» — можно положить число в колонку `TEXT`. В «взрослых» СУБД (PostgreSQL, MySQL) типы строгие, и это хорошо: база сама не даст записать `'десять'` в колонку `age`.

**Попробуй сам:**

```sql
-- Какие типы данных у нас сейчас в таблицах? (консоль SQLite)
.schema users

-- Сколько весит база? (терминал Linux, вне консоли)
-- ls -lh shop.db
```

**Задание:** открой демо-базу заново и добавь в таблицу `users` колонку `bonus` с типом `NUMERIC` (команду `ALTER TABLE` разберём позже — сейчас просто посмотри на ошибку/результат).

**Самопроверка:**

```sql
ALTER TABLE users ADD COLUMN bonus NUMERIC;
```

Колонка `bonus` появится со значением `NULL` у всех строк. Команды `ALTER TABLE` для изменения структуры — это часть DDL, подробнее в разделе «DDL и ограничения».

---

## Установка: SQLite для практики, MySQL/PostgreSQL

### SQLite (рекомендуется для этого учебника)

Ничего устанавливать чаще всего не нужно.

```bash
# Debian/Ubuntu/ALT-подобные системы:
sudo apt-get update && sudo apt-get install sqlite3

# Проверка:
sqlite3 --version
```

### MySQL / MariaDB (если нужен сервер)

Пример из заметок по ALT Linux:

```bash
sudo apt-get update && sudo apt-get install MySQL-server
sudo systemctl enable --now mysqld
systemctl status mysqld
```

После установки зайди и задай пароль root:

```sql
-- первоначальный вход (пароль пустой):
mysql -u root

-- внутри консоли:
ALTER USER 'root'@'localhost' IDENTIFIED BY 'ВашПароль';
-- выйти — символ \q
```

Создать базу и пользователя:

```sql
CREATE DATABASE my_shop;
CREATE USER 'shop_app'@'localhost' IDENTIFIED BY 'shop_pass';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE ON my_shop.* TO 'shop_app'@'localhost';
```

По умолчанию сетевой доступ к mysqld **отключён** (`skip-networking`). Чтобы разрешить подключение по TCP, закомментируй строку `skip-networking` и перезапусти сервис:

```bash
sudo nano /etc/my.cnf.d/server.cnf
#  #skip-networking   ← закомментируй
sudo systemctl restart mysqld
netstat -lnpt | grep mysqld   # должен слушаться порт 3306
```

### PostgreSQL (сервер)

PostgreSQL — самый мощный выбор для практики. Главе о нём посвящён отдельный учебник, здесь — минимум:

```bash
# ALT / Debian-подобные:
sudo apt-get update && sudo apt-get install postgresql
sudo systemctl enable --now postgresql

sudo -u postgres psql            # консоль суперпользователя
CREATE ROLE student LOGIN PASSWORD '123';
CREATE DATABASE shop OWNER student;
\q
psql -h localhost -U student shop
```

> Совет: все учебные запросы этого файла можно выполнить и в PostgreSQL — скрипт демо-базы полностью совместим.

**Задание:** установи SQLite и создай демо-базу из раздела выше.

**Самопроверка:**

```bash
sqlite3 --version
sqlite3 shop.db < shop.sql
sqlite3 shop.db "SELECT COUNT(*) FROM products;"
```

Последняя команда должна вернуть `10` (после добавления настольной лампы).

---

## Первый запрос: SELECT

`SELECT` — самый важный оператор. Он «выбирает» данные.

Синтаксис:

```sql
SELECT колонки FROM таблица;
```

- `*` — все колонки.
- можно перечислять колонки через запятую — вернётся только то, что нужно.
- колонкам можно дать псевдоним через `AS`.

**Порядок, в котором СУБД реально выполняет запрос** (важно помнить всегда):

```
      1                   2                3                 4
      ▼                   ▼                ▼                 ▼
   FROM users  ──►  WHERE age > 18  ──►  GROUP BY city  ──►  HAVING count(*) > 5
                                                                   │
     7                    6                 5                     ▼
     ▼                    ▼                 ▼                 SELECT city,
   LIMIT 10  ◄──  ORDER BY cnt DESC  ◄──  SELECT city, count(*) AS cnt
```

То есть: сначала берутся таблицы (`FROM`), потом фильтрация строк (`WHERE`), затем группировка (`GROUP BY`), фильтрация групп (`HAVING`), вычисление выбранных столбцов (`SELECT`), сортировка (`ORDER BY`) и, наконец, ограничение выдачи (`LIMIT`). Поэтому псевдоним из `SELECT` нельзя использовать в `WHERE`, но можно в `ORDER BY`.

**Попробуй сам:**

```sql
-- Все колонки всех пользователей
SELECT * FROM users;

-- Только имя и город
SELECT name, city FROM users;

-- С псевдонимом и переименованием заголовка
SELECT name AS "Имя клиента", age AS "Возраст" FROM users;

-- Виртуальные колонки: можно считать прямо в SELECT
SELECT name, age, age - 18 AS "Сколько сверх 18" FROM users;
```

**Задание:** выведи названия, категории и цены всех товаров дешевле «электроники» — просто выведи колонки `name`, `category`, `price` из `products` (фильтрация уже в следующем разделе).

**Самопроверка:**

```sql
SELECT name, category, price FROM products;
```

Без `WHERE` вернутся все 10 товаров.

---

## Фильтрация: WHERE

`WHERE` отбирает только строки, подходящие под условие.

Операторы сравнения: `=`, `<>` (не равно), `>`, `<`, `>=`, `<=`.

Логические операторы: `AND`, `OR`, `NOT`.

**Попробуй сам:**

```sql
-- Пользователи старше 25 лет
SELECT name, age FROM users WHERE age > 25;

-- Точное равенство строк
SELECT name, city FROM users WHERE city = 'Москва';

-- Два условия сразу
SELECT name, age FROM users WHERE age >= 25 AND city = 'Москва';

-- Не равно
SELECT name FROM users WHERE city <> 'Москва';

-- LIKE — поиск по шаблону: % = любая последовательность, _ = один символ
SELECT name FROM products WHERE name LIKE 'К%';      -- начинается на "К"
SELECT name FROM products WHERE name LIKE '%ы';      -- заканчивается на "ы"

-- IN — попадание в список
SELECT name FROM products WHERE category IN ('Электроника', 'Книги');

-- BETWEEN — диапазон включительно
SELECT name, price FROM products WHERE price BETWEEN 1000 AND 5000;
```

Шаблоны LIKE:

| Шаблон | Значение |
| --- | --- |
| `LIKE 'A%'` | начинается с A |
| `LIKE '%a'` | заканчивается на a |
| `LIKE '%анн%'` | содержит "анн" в любом месте |
| `LIKE '_аты'` | любой символ + "аты" (например "Ваты") |
| `LIKE 'a%o'` | начинается на a, заканчивается на o |

**Задание:** найди пользователей, у которых возраст в диапазоне от 20 до 30 лет, проживающих не в Москве.

**Самопроверка:**

```sql
SELECT name, age, city FROM users
WHERE age BETWEEN 20 AND 30 AND city <> 'Москва';
```

Результат: Козлов Дмитрий (27, Новосибирск), Новикова Елена (23, Екатеринбург). Иванов Иван (25) — Москва, поэтому отсеется.

---

## Сортировка: ORDER BY

`ORDER BY колонка ASC|DESC` сортирует строки: `ASC` по возрастанию (по умолчанию), `DESC` по убыванию. Сортировать можно по нескольким колонкам сразу.

**Попробуй сам:**

```sql
-- По возрастанию цены
SELECT name, price FROM products ORDER BY price;

-- По убыванию
SELECT name, price FROM products ORDER BY price DESC;

-- Сначала категория, внутри — цена по убыванию
SELECT name, category, price FROM products
ORDER BY category, price DESC;

-- Сортировка по порядковому номеру колонки (1 = name, 2 = price)
SELECT name, price FROM products ORDER BY 2 DESC;
```

**Задание:** выведи города пользователей, отсортированные по алфавиту, и укажи для каждого количество букв в названии города.

**Самопроверка:**

```sql
SELECT DISTINCT city, length(city) AS len FROM users
ORDER BY city;
```

По алфавиту: Екатеринбург, Казань, Москва, Новосибирск, Санкт-Петербург.

---

## LIMIT и OFFSET

`LIMIT N` — оставить только первые N строк. `OFFSET M` — пропустить первые M строк. Вместе это реализует «страницы» результатов (пагинация).

```
 OFFSET 2  ┌─────────────┐
           │ пропускаем 2│
 ┌─────────▼───────────┐
 │ 3. Кофеварка        │
 │ 4. Куртка           │  LIMIT 2  ─┐
 └─────────────────────┘            │
 ... первый запрос: LIMIT 2 OFFSET 2│
                                    ▼
                        вернутся: Кофеварка, Куртка
```

**Попробуй сам:**

```sql
-- Топ-3 самых дорогих товара
SELECT name, price FROM products ORDER BY price DESC LIMIT 3;

-- Вторая «страница» по 3 товара
SELECT name, price FROM products ORDER BY price DESC LIMIT 3 OFFSET 3;

-- Самые молодые пользователи, только 2
SELECT name, age FROM users ORDER BY age ASC LIMIT 2;
```

**Задание:** выведи товары с 4-го по 6-й в списке самых дорогих (то есть пропусти 3 самых дорогих).

**Самопроверка:**

```sql
SELECT name, price FROM products ORDER BY price DESC LIMIT 3 OFFSET 3;
```

Результат: Наушники (3999), Чайник (2999), Джинсы (2599).

---

## Уникальные значения: DISTINCT

`SELECT DISTINCT колонки` убирает повторяющиеся строки из результата.

**Попробуй сам:**

```sql
-- Без DISTINCT города повторяются
SELECT city FROM users;

-- С DISTINCT остаются только уникальные
SELECT DISTINCT city FROM users;

-- Уникальные пары (категория, ...)
SELECT DISTINCT category FROM products;
```

**Задание:** посчитай, сколько уникальных городов в таблице users (подсказка: `COUNT(DISTINCT ...)` — увидим в агрегациях, но можно использовать и `SELECT DISTINCT` + глазами).

**Самопроверка:**

```sql
SELECT COUNT(DISTINCT city) FROM users;
```

Должно получиться `5` (Москва встречается дважды — один раз дубль отбрасывается).

---

## Агрегации: COUNT, SUM, AVG, MIN, MAX

Агрегатные функции сворачивают **много строк в одно число**:

- `COUNT(*)` — количество строк; `COUNT(колонка)` — количество не-NULL значений.
- `SUM(колонка)` — сумма.
- `AVG(колонка)` — среднее.
- `MIN`, `MAX` — минимум и максимум.

```
 SUM(price)
 ┌──────────┬─────────┐
 │ name     │ price   │
 │ Ноутбук  │ 59999   │──┐
 │ Смартфон │ 24999   │  │  SUM = 59999+24999+...
 │ Наушники │  3999   │──┘  = 93896
 └──────────┴─────────┘
```

**Попробуй сам:**

```sql
-- Сколько всего пользователей?
SELECT COUNT(*) AS total FROM users;

-- Сколько товаров в категории «Электроника»?
SELECT COUNT(*) FROM products WHERE category = 'Электроника';

-- Общая стоимость всех товаров на складе по цене
SELECT SUM(price * stock) AS warehouse_value FROM products;

-- Средняя цена электроники
SELECT AVG(price) AS avg_price FROM products WHERE category = 'Электроника';

-- Диапазон цен
SELECT MIN(price) AS cheapest, MAX(price) AS dearest FROM products;

-- Средний чек всех покупок (из order_items, где price зафиксирован на момент продажи)
SELECT SUM(quantity * price) / COUNT(*) AS avg_check FROM order_items;
```

**Задание:** посчитай выручку от всех заказов со статусом `completed` (используй `order_items` и подзапрос в `WHERE` — если получится, или просто умножь сумму).

**Самопроверка:**

```sql
SELECT SUM(oi.quantity * oi.price) AS revenue
FROM order_items oi
JOIN orders o ON o.id = oi.order_id
WHERE o.status = 'completed';
```

Выручка по выполненным заказам: 122 489.00.

---

## Группировка: GROUP BY и HAVING

`GROUP BY колонка` разбивает строки на группы — по одной на каждое уникальное значение. Агрегации тогда считаются **внутри каждой группы**.

```
 без GROUP BY:                        с GROUP BY category:
 ┌─────────────┬──────────┐           ┌────────────┬──────┐
 │ category    │ price    │           │ category   │  N   │
 │ Электроника │ 59999    │           │ Электроника│  3   │
 │ Электроника │ 24999    │           │ Одежда     │  3   │
 │ Одежда      │  899     │           │ Дом        │  3   │
 │ ...         │ ...      │           │ Книги      │  1   │
 └─────────────┴──────────┘           └────────────┴──────┘
```

`HAVING` фильтрует **группы** (в отличие от `WHERE`, который фильтрует строки **до** группировки).

**Попробуй сам:**

```sql
-- Сколько товаров в каждой категории и средняя цена
SELECT category, COUNT(*) AS cnt, AVG(price) AS avg_p
FROM products
GROUP BY category;

-- Сколько заказов у каждого пользователя
SELECT user_id, COUNT(*) AS orders_cnt
FROM orders
GROUP BY user_id;

-- Только те пользователи, у которых больше 1 заказа
SELECT user_id, COUNT(*) AS cnt
FROM orders
GROUP BY user_id
HAVING COUNT(*) > 1;

-- Кто потратил больше 5000: join + группировка + фильтр групп
SELECT o.user_id, SUM(oi.quantity * oi.price) AS spent
FROM order_items oi
JOIN orders o ON o.id = oi.order_id
GROUP BY o.user_id
HAVING SUM(oi.quantity * oi.price) > 5000
ORDER BY spent DESC;
```

**Задание:** посчитай для каждой категории товаров их суммарный остаток на складе и выведи только категории с суммарным остатком меньше 150 штук.

**Самопроверка:**

```sql
SELECT category, SUM(stock) AS total_stock
FROM products
GROUP BY category
HAVING SUM(stock) < 150;
```

Результат: Электроника → 137, Книги → 150 (не проходит, не выводится), Дом → 105. То есть в результатах будут Электроника (137) и Дом (105).

---

## JOIN: соединяем таблицы

Данные лежат в разных таблицах, а вопросы обычно требуют их вместе: «выведи имя покупателя и его заказ». `JOIN` соединяет таблицы по совпадающим значениям.

**Соединение по условию `ON`: берём строку из левой таблицы, ищем совпадения в правой по ключу, склеиваем.**

```
 users                              orders
┌────┬──────────────┐               ┌────┬─────────┬───────────────┐
│ id │ name         │               │ id │ user_id │ order_date    │
│ 1  │ Иванов Иван  │               │ 1  │    1    │ 2024-01-10    │
│ 2  │ Петрова Анна │               │ 2  │    1    │ 2024-02-14    │
│ 3  │ Сидоров Олег │               │ 3  │    2    │ 2024-01-22    │
└────┴──────────────┘               └────┴─────────┴───────────────┘
         JOIN ON orders.user_id = users.id   (INNER: только совпадения)

result:
┌──────────────┬────┬───────────────┐
│ name         │ id │ order_date    │
│ Иванов Иван  │ 1  │ 2024-01-10    │   user_id=1 → users.id=1
│ Иванов Иван  │ 2  │ 2024-02-14    │   user_id=1 → users.id=1
│ Петрова Анна │ 3  │ 2024-01-22    │   user_id=2 → users.id=2
└──────────────┴────┴───────────────┘
```

Синтаксис (варианты эквивалентны):

```sql
SELECT ...
FROM users JOIN orders ON orders.user_id = users.id;
-- то же самое короче:
SELECT ...
FROM users JOIN orders ON orders.user_id = users.id;
```

Псевдонимы таблиц обязательны для читабельности:

```sql
SELECT u.name, o.id, o.order_date
FROM users u
JOIN orders o ON o.user_id = u.id;
```

**Попробуй сам:**

```sql
-- Каждый заказ вместе с именем покупателя
SELECT u.name, o.id AS order_id, o.order_date, o.status
FROM users u
JOIN orders o ON o.user_id = u.id
ORDER BY o.order_date;

-- Товары из конкретного заказа (двойной join)
SELECT o.id AS order_id, p.name, oi.quantity, oi.price
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
JOIN products p ON p.id = oi.product_id
WHERE o.id = 1;
```

**Задание:** выведи имя покупателя, дату и сумму каждого заказа со статусом `completed`.

**Самопроверка:**

```sql
SELECT u.name, o.id AS order_id, o.order_date,
       SUM(oi.quantity * oi.price) AS total
FROM orders o
JOIN users u ON u.id = o.user_id
JOIN order_items oi ON oi.order_id = o.id
WHERE o.status = 'completed'
GROUP BY o.id, u.name, o.order_date
ORDER BY o.order_date;
```

---

## INNER, LEFT, RIGHT, FULL, CROSS

**INNER JOIN** — только совпадающие строки обеих таблиц (по умолчанию слово `INNER` можно опускать).

**LEFT JOIN** — все строки левой таблицы + совпадения из правой; чего нет — заполняется `NULL`.

**RIGHT JOIN** — зеркально: все строки правой + совпадения из левой.

**FULL JOIN** — все строки обеих таблиц; что не совпало — `NULL`.

**CROSS JOIN** — декартово произведение: каждый с каждым (без `ON`).

```
 LEFT JOIN (users LEFT JOIN orders):
 users: A,B,C        orders: заказы только A(1 шт) и B(2 шт)
┌────┬─────────┐     ┌────┬─────────┐
│ id │ name    │     │ id │ user_id │
│ 1  │ Иванов  │     │ 1  │   1     │
│ 2  │ Петрова │     │ 2  │   2     │
│ 3  │ Сидоров │     │ 3  │   2     │
└────┴─────────┘     └────┴─────────┘
 результат:
┌──────────┬──────┬──────────┐
│ name     │ o.id │ user_id  │
│ Иванов   │  1   │   1      │
│ Петрова  │  2   │   2      │
│ Петрова  │  3   │   2      │
│ Сидоров  │ NULL │ NULL     │   ← нет заказов → NULL
└──────────┴──────┴──────────┘
```

**Попробуй сам:**

```sql
-- LEFT JOIN: все пользователи и их заказы (видно, кто ничего не заказал)
SELECT u.name, COUNT(o.id) AS orders_count
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
GROUP BY u.name
ORDER BY orders_count DESC;

-- LEFT JOIN: товары, которые ни разу не продавали
SELECT p.name, oi.quantity
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.id
WHERE oi.quantity IS NULL;

-- RIGHT JOIN и FULL JOIN в SQLite (версия 3.39+) тоже работают:
SELECT u.name, o.id FROM users u RIGHT JOIN orders o ON o.user_id = u.id LIMIT 3;
SELECT u.name, o.id FROM users u FULL JOIN orders o ON o.user_id = u.id LIMIT 3;

-- CROSS JOIN: каждая пара «пользователь × товар» (ограничим 5, иначе 60 строк)
SELECT u.name, p.name FROM users u CROSS JOIN products p LIMIT 5;
```

> Замечание: в старых версиях SQLite `RIGHT/FULL JOIN` не поддерживались; с версии 3.39 они есть. PostgreSQL и MySQL `FULL JOIN` умеют (в MySQL 8 тоже).

**Задание:** составь список всех пользователей и общее количество позиций в их заказах (сумму `quantity`). У кого заказов нет — выведи `0`.

**Самопроверка:**

```sql
SELECT u.name, COALESCE(SUM(oi.quantity), 0) AS items
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
LEFT JOIN order_items oi ON oi.order_id = o.id
GROUP BY u.name
ORDER BY items DESC;
```

`COALESCE` превращает NULL в 0 — подробнее в разделе «Работа с NULL».

---

## Self-join: таблица сама с собой

Некоторые вопросы связаны со сравнением строк **внутри одной таблицы**: «найди людей из одного города», «сотрудника и его руководителя». Тогда таблица соединяется сама с собой через два разных псевдонима.

```
 users AS a                        users AS b
┌────┬──────────────┬────────┐    ┌────┬──────────────┬────────┐
│ id │ name         │ city   │    │ id │ name         │ city   │
│ 1  │ Иванов       │ Москва │    │ 1  │ Иванов       │ Москва │
│ 4  │ Смирнова     │ Москва │    │ 4  │ Смирнова     │ Москва │
└────┴──────────────┴────────┘    └────┴──────────────┴────────┘
               JOIN a.city = b.city AND a.id < b.id
 результат: пара «Иванов, Смирнова» (без дублей «Смирнова, Иванов»)
```

**Попробуй сам:**

```sql
-- Пары пользователей из одного города
SELECT a.name AS u1, b.name AS u2, a.city
FROM users a
JOIN users b ON a.city = b.city AND a.id < b.id;
```

**Задание:** в демо-базе `users` — это покупатели, а не сотрудники. Поэтому придумай вопрос сам и реши его: найди все пары товаров одинаковой категории (цена не важна).

**Самопроверка:**

```sql
SELECT a.name AS left_product, b.name AS right_product, a.category
FROM products a
JOIN products b ON a.category = b.category AND a.id < b.id
ORDER BY a.category;
```

Например, в «Электронике» это Ноутбук↔Смартфон, Ноутбук↔Наушники, Смартфон↔Наушники.

---

## Подзапросы, EXISTS, IN

**Подзапрос** — это `SELECT`, вложенный в другой запрос. Он умеет почти всё, что и обычный запрос.

Места вложения:

- в `SELECT` — посчитать значение для каждой строки;
- в `FROM` — использовать результат подзапроса как «таблицу»;
- в `WHERE` — сравнить с результатом подзапроса.

**Попробуй сам:**

```sql
-- В WHERE: товары дороже средней цены
SELECT name, price FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- В WHERE с IN: пользователи, у которых есть заказы
SELECT name FROM users
WHERE id IN (SELECT DISTINCT user_id FROM orders);

-- В FROM: подзапрос как таблица-источник
SELECT totals.user_id, totals.cnt
FROM (SELECT user_id, COUNT(*) AS cnt FROM orders GROUP BY user_id) AS totals
WHERE totals.cnt > 1;

-- EXISTS — проверка «существует ли хотя бы одна строка»
-- Пользователи, у которых НЕТ выполненного заказа:
SELECT name FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM orders o
    WHERE o.user_id = u.id AND o.status = 'completed'
);

-- Товары, которые вообще ни разу не продавались
SELECT name FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM order_items oi WHERE oi.product_id = p.id
);
```

`EXISTS` часто быстрее `IN`, потому что прекращает поиск при первом совпадении.

**Задание:** выведи товары, которые были куплены в количестве больше 1 штуки хотя бы в одном заказе (используй подзапрос с `IN`).

**Самопроверка:**

```sql
SELECT DISTINCT name FROM products
WHERE id IN (
    SELECT product_id FROM order_items WHERE quantity > 1
);
```

Это Футболка (заказ 2 — 2 шт., заказ 9 — 3 шт.), Чайник (заказ 5 — 2 шт.), Смартфон (заказ 8 — 2 шт.) и Книга (заказ 10 — 5 шт.).

### Коррелированные подзапросы

**Коррелированный подзапрос** — подзапрос, который ссылается на внешний запрос и выполняется **построчно** для каждой строки внешнего запроса.

```sql
-- Для каждого товара посчитать число заказов (подзапрос выполняется N раз)
SELECT p.name,
       (SELECT COUNT(*) FROM order_items oi
         WHERE oi.product_id = p.id) AS orders_cnt
FROM products p;

-- Пользователи, у которых есть заказы (EXISTS — тоже коррелированный)
SELECT name FROM users u
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.user_id = u.id
);
```

Отличие от обычного подзапроса: коррелированный **нельзя выполнить отдельно** — он зависит от текущей строки внешнего запроса.

### CTE (Common Table Expression)

**CTE** — именованный подзапрос через `WITH`, читается сверху вниз, как «переменная»:

```sql
-- Простой CTE
WITH expensive AS (
    SELECT * FROM products WHERE price > 10000
)
SELECT name, price FROM expensive;

-- Несколько CTE + использование в JOIN
WITH order_totals AS (
    SELECT o.user_id, SUM(oi.quantity * oi.price) AS total
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.id
    GROUP BY o.user_id
)
SELECT u.name, ot.total
FROM order_totals ot
JOIN users u ON u.id = ot.user_id
ORDER BY ot.total DESC;
```

Где что: CTE многократно используются и проще для сложных запросов; подзапрос же — для простых разовых условий. Ещё есть **рекурсивные CTE** (`WITH RECURSIVE`) для деревьев и иерархий.

---

## Подзапросы или JOIN?

Оба инструмента решают похожие задачи, но по-разному:

| Критерий | JOIN | Подзапрос |
| --- | --- | --- |
| Что делает | склеивает таблицы по ключу | выполняет вложенный SELECT, потом использует результат |
| Зачем | вывести данные сразу из нескольких таблиц | отфильтровать по вычисленному значению |
| Читаемость | хороша, когда нужно много колонок из разных таблиц | хорош для «одного вопроса» |
| Производительность | обычно оптимальнее | для `IN/EXISTS` бывает быстрее |
| Побочные эффекты | может размножать строки (если join не с ключом) | нет |

**Золотое правило:** если результату нужны колонки из двух таблиц — используй JOIN. Если нужно «отфильтровать строки одной таблицы по факту наличия/значению в другой» — сначала подумумй о подзапросе, потом сравни с EXISTS/IN.

**Попробуй сам:**

```sql
-- Одна и та же задача двумя способами
-- Способ 1: JOIN
SELECT DISTINCT u.name
FROM users u JOIN orders o ON o.user_id = u.id
WHERE o.status = 'completed';

-- Способ 2: подзапрос с IN (без join — только таблица users в внешнем запросе)
SELECT name FROM users
WHERE id IN (SELECT DISTINCT user_id FROM orders WHERE status = 'completed');
```

Результат одинаковый: Иванов Иван, Петрова Анна, Смирнова Мария, Сидоров Олег.

**Задание:** почувствуй разницу — («а») выведи название заказанных товаров с их ценой из order_items с помощью JOIN, («б») выведи те же товары подзапросом. Подумай, какой способ естественнее.

**Самопроверка:**

```sql
-- (а) JOIN — тут колонки из двух таблиц, поэтому JOIN правильный выбор:
SELECT DISTINCT p.name, oi.price
FROM products p JOIN order_items oi ON oi.product_id = p.id;

-- (б) подзапросом — приходится вытаскивать цену из order_items в WHERE,
--     что неудобно: SELECT DISTINCT name FROM products WHERE id IN (SELECT product_id FROM order_items);
```

Вывод лучше делать только данными из products — тогда подзапрос достаточен. Когда нужна цена на момент покупки (`oi.price`) — без JOIN не обойтись.

---

## UNION: складываем результаты

`UNION` объединяет два запроса в один список. Правила:

- одинаковое количество колонок;
- совместимые типы;
- `UNION` убирает дубликаты, `UNION ALL` — оставляет.

```
 SELECT 1            SELECT 1           UNION →  1,2,3
 ┌────────┐          ┌────────┐
 │  1     │          │  2     │   (без дублей)
 │  2     │          │  1     │
 │  3     │          └────────┘
 └────────┘
```

**Попробуй сам:**

```sql
-- Список «москвичей» и недорогих товаров (одна колонка — дорожка-строка)
SELECT 'пользователь' AS who, name FROM users WHERE city = 'Москва'
UNION
SELECT 'товар', name FROM products WHERE price < 1000
ORDER BY name;

-- UNION объединяет, UNION ALL позволяет дубли
SELECT city FROM users WHERE age < 25
UNION
SELECT city FROM users WHERE age >= 25;
```

**Задание:** выведи одним списком все названия категорий из products и все города из users, пометив источник строки.

**Самопроверка:**

```sql
SELECT 'категория' AS src, category AS value FROM products
UNION
SELECT 'город', city FROM users
ORDER BY src, value;
```

Колонок должно быть две: `src` и `value`.

---

## CASE: условия в запросах

`CASE` — это «if/else» внутри SQL. Возвращает значение по условию.

```sql
CASE
    WHEN условие1 THEN результат1
    WHEN условие2 THEN результат2
    ELSE результат_по_умолчанию
END
```

**Попробуй сам:**

```sql
-- Полка цен: дёшево / средне / дорого
SELECT name, price,
  CASE
    WHEN price < 1000 THEN 'дёшево'
    WHEN price < 15000 THEN 'средне'
    ELSE 'дорого'
  END AS price_level
FROM products
ORDER BY price;

-- Преобразуем статус заказа в человекопонятный
SELECT id, order_date,
  CASE status
    WHEN 'new' THEN 'новый'
    WHEN 'pending' THEN 'в обработке'
    WHEN 'completed' THEN 'выполнен'
    WHEN 'cancelled' THEN 'отменён'
  END AS status_ru
FROM orders;
```

**Задание:** посчитай, сколько товаров «дёшево», «средне» и «дорого» — с помощью `CASE` внутри `SUM` или `COUNT` с фильтром.

**Самопроверка:**

```sql
SELECT
  SUM(CASE WHEN price < 1000 THEN 1 ELSE 0 END) AS cheap,
  SUM(CASE WHEN price BETWEEN 1000 AND 14999 THEN 1 ELSE 0 END) AS middle,
  SUM(CASE WHEN price >= 15000 THEN 1 ELSE 0 END) AS expensive
FROM products;
```

Дёшево — 2, средне — 5, дорого — 3.

---

## Строковые функции

SQLite-функции для строк (в PostgreSQL/MySQL аналоги есть, но имена иногда другие):

| Функция | Что делает |
| --- | --- |
| `UPPER(s)`, `LOWER(s)` | верхний/нижний регистр |
| `LENGTH(s)` | число символов |
| `substr(s, start, len)` | подстрока (нумерация с 1) |
| `instr(s, подстрока)` | позиция подстроки (0 = нет) |
| `TRIM(s)` | убрать пробелы по краям |
| `REPLACE(s, что, чем)` | замена части строки |
| `s1 || s2` | конкатенация (склейка) |
| `printf('%d', s)` | форматирование (аналог sprintf) |

**Попробуй сам:**

```sql
-- Имя заглавными и длина e-mail
SELECT UPPER(name) AS name_upper, LENGTH(email) AS email_len
FROM users WHERE id = 1;

-- Логин — часть e-mail до @
SELECT substr(email, 1, instr(email, '@') - 1) AS login FROM users;

-- Склейка
SELECT name || ' (' || city || ')' AS full FROM users LIMIT 3;

-- Замена и обрезка
SELECT REPLACE(name, ' Петрова', '') FROM users WHERE id = 2;
SELECT TRIM('   SQL   ') AS trimmed;
```

**Задание:** выведи e-mail, у которого после `@` стоит `example.com`, в виде «имя: ДОМЕН» заглавными буквами.

**Самопроверка:**

```sql
SELECT UPPER(email) FROM users;   -- простой вариант
-- или с разбором на части:
SELECT substr(email, 1, instr(email, '@') - 1) || ':' ||
       UPPER(substr(email, instr(email, '@') + 1)) AS split
FROM users;
```

---

## Работа с датами

В демо-базе даты хранятся в формате ISO `YYYY-MM-DD` — так их можно сравнивать как обычные строки, и сортировка совпадёт с хронологической.

SQLite-функции дат:

| Функция | Что делает |
| --- | --- |
| `date('now')` | сегодня `2026-09-07` |
| `time('now')` | текущее время |
| `date(дата, '+7 days')` | дата + 7 дней |
| `julianday(дата)` | дата как дробное число дней |
| `strftime('%Y', дата)` | год, `%m` — месяц, `%d` — день, `%y` — 2-значный год |

> В PostgreSQL вместо этого `CURRENT_DATE`, `now()`, `EXTRACT(YEAR FROM d)`, `AGE(d)`; в MySQL — `NOW()`, `CURDATE()`, `DATE_ADD()`, `DATE_FORMAT()`.

**Попробуй сам:**

```sql
-- Текущая дата и время
SELECT date('now') AS today, strftime('%Y-%m-%d %H:%M', 'now') AS now_ts;

-- Разбить дату на год/месяц
SELECT order_date,
       strftime('%Y', order_date) AS yyyy,
       strftime('%m', order_date) AS mm
FROM orders WHERE strftime('%Y', order_date) = '2024' LIMIT 3;

-- Сколько дней прошло с заказа (julianday даёт дробные дни)
SELECT id, order_date,
       CAST(julianday('now') - julianday(order_date) AS INTEGER) AS days_ago
FROM orders LIMIT 3;

-- Даты в будущем
SELECT date('now', '+1 year') AS next_year;
```

**Задание:** выведи заказы, сделанные в первом квартале 2024 года (январь-март), и число дней с момента заказа до конца марта 2024.

**Самопроверка:**

```sql
SELECT id, order_date
FROM orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-03-31';
```

Это заказы 1, 2, 3, 4, 5, 6.

---

## Работа с NULL

`NULL` — «значение отсутствует», «неизвестно». Это НЕ ноль и НЕ пустая строка.

Правила:

- `NULL = NULL` — не равно! Проверять надо `IS NULL` / `IS NOT NULL`.
- `NULL` в арифметике «заражает» результат: `1 + NULL = NULL`.
- `COUNT(*)` считает все строки, `COUNT(колонка)` — только не-NULL.
- `COALESCE(a, b, c)` — первое не-NULL значение.
- `IFNULL(a, b)` — то же, но ровно два аргумента (SQLite/MySQL; в PG есть `IFNULL`? нет — там только `COALESCE`).

**Попробуй сам:**

```sql
-- Кто и сколько — COLUMN vs *:
SELECT COUNT(*) AS total_rows, COUNT(city) AS cities_filled FROM users;

-- Проверка на NULL
SELECT name, city FROM users WHERE city IS NOT NULL;

-- COALESCE даёт значение по умолчанию
SELECT name, COALESCE(NULL, 'нет данных') AS m FROM users LIMIT 1;

-- NULL заражает арифметику
SELECT 10 + NULL AS poisoned;
```

**Задание:** найди все товары с нулевым остатком, но выведи не `NULL`, а поясняющий текст.

**Самопроверка:**

```sql
SELECT name, COALESCE(stock, 0) AS stock FROM products WHERE stock IS NULL;
```

В демо-базе все остатки заполнены, поэтому вернётся пустая выборка — это тоже правильный результат.

---

## Индексы: ускоряем запросы

Когда таблица большая, `<` , `=`, `JOIN` по столбцу «прочёсывают» каждую строку — это **полное сканирование** (seq scan). Индекс — это отдельная структура, которая позволяет искать по значению сразу, как указатель в книге.

**Идея B-дерева:** отсортированное дерево, в листьях — ссылки на строки.

```
                ┌────────────┐
                │     50     │
                └───┬────┬───┘
               ┌────┘    └────┐
        ┌──────▼─────┐  ┌─────▼──────┐
        │    10,25   │  │   75,100   │
        └──┬────┬────┘  └────┬───┬───┘
           │    │           │   │
        ┌──▼─┐ ┌▼──┐     ┌──▼─┐┌▼──┐
        │... │ │...│     │... ││...│  ← листья: отсортированные
        └────┘ └───┘     └────┘└───┘     значения + указатели
                                          на строки таблицы
```

Поиск идёт «сверху вниз» и за O(log N) шагов вместо O(N). Чем больше таблица — тем заметнее выигрыш.

- Индексы **не видны в SELECT** — база использует их сама, когда выгодно.
- Создавать индекс на каждой колонке нельзя бездумно — он замедляет `INSERT/UPDATE/DELETE`.
- `JOIN`, `WHERE`, `ORDER BY` по колонке — кандидаты на индекс.
- `PRIMARY KEY` и `UNIQUE` индексируются автоматически.

**Попробуй сам:**

```sql
-- Создаём индекс (SQLite)
CREATE INDEX idx_products_category ON products(category);

-- Убедиться, что индекс используется, можно через EXPLAIN QUERY PLAN:
EXPLAIN QUERY PLAN SELECT * FROM products WHERE category = 'Электроника';
```

> В PostgreSQL ту же роль выполняет `EXPLAIN ANALYZE` — подробнее в учебнике по PostgreSQL.

**Задание:** создай индекс на `order_items.product_id` и объясни, почему это ускорит запросы из раздела про JOIN.

**Самопроверка:**

```sql
CREATE INDEX idx_oi_product ON order_items(product_id);
```

Чем чаще соединяем `order_items` с `products` по `product_id`, тем полезнее индекс: JOIN перестанет прочёсывать всю таблицу.

---

## Транзакции и ACID

**Транзакция** — это последовательность операций, которая выполняется «как одно целое».

```
 BEGIN;
   UPDATE users SET age = age + 1 WHERE id = 1;
   INSERT INTO orders (id, user_id, order_date) VALUES (11, 1, '2024-06-01');
 ── всё или ничего ──
 COMMIT;    -- применяем
   или
 ROLLBACK;  -- отменяем всё, как ни в чём не бывало
```

Мнемоника **ACID**:

```
 A — Atomicity      атомарность:   все шаги или ни одного
 C — Consistency    согласованность: база переходит из валидного состояния в валидное
 I — Isolation      изолированность: параллельные транзакции не мешают друг другу
 D — Durability     надёжность:    после COMMIT данные переживут перезагрузку
```

> В SQLite транзакции начинаются `BEGIN`, заканчиваются `COMMIT` или `ROLLBACK`. В PostgreSQL/MySQL по умолчанию каждый запрос — своя транзакция (autocommit), явные `BEGIN` тоже работают.

Ограничения для чтения: под управлением **MVCC** (многоверсионность) СУБД при обновлении не перезаписывает строку, а создаёт новую версию — чтецы видят стабильный снимок данных. MVCC встроен в PostgreSQL; в MySQL поддерживается движком **InnoDB**.

> Внимание: в MySQL команды DDL (`CREATE`, `ALTER`, `DROP`, `TRUNCATE`) выполняют неявный `COMMIT` и не откатываются. В PostgreSQL DDL транзакционен.

**Попробуй сам:**

```sql
-- Откат: вставка не выживет после ROLLBACK
BEGIN;
INSERT INTO users (id, name, email, age) VALUES (100, 'Тест', 'test@t.ru', 30);
SELECT COUNT(*) AS in_txn FROM users;   -- внутри транзакции видно 7
ROLLBACK;
SELECT COUNT(*) AS after_rollback FROM users;  -- снова 6!

-- Коммит наоборот закрепляет изменения
BEGIN;
INSERT INTO users (id, name, email, age) VALUES (100, 'Тест', 'test@t.ru', 30);
COMMIT;
SELECT COUNT(*) FROM users;  -- теперь 7
DELETE FROM users WHERE id = 100;  -- убери тестовую строку
```

**Задание:** опиши словами (не выполняй): что сделает этот код и почему результат первый `SUM` не равен второму:

```sql
BEGIN;
UPDATE products SET stock = stock - 50 WHERE id = 1;   -- стало 12 - 50 = -38
SELECT SUM(stock) FROM products;  -- первый
ROLLBACK;
SELECT SUM(stock) FROM products;  -- второй
```

**Самопроверка:**

Первое `SUM` внутри транзакции видит уменьшенный остаток (можно даже отрицательный — CHECK разрешает, мы не запретили отрицательные остатки). После `ROLLBACK` изменения откатываются, второе `SUM` — исходное значение. Главная мысль: транзакции дают возможность «примерять» изменения и откатываться.

---

## DML: INSERT, UPDATE, DELETE

**DML** — язык манипуляции данными (`INSERT`, `UPDATE`, `DELETE`, `SELECT`).

```sql
-- Вставить одну строку
INSERT INTO products (id, name, category, price, stock)
VALUES (11, 'Микрофон', 'Электроника', 3499, 40);

-- Вставить несколько строк (bulk insert)
INSERT INTO products (id, name, category, price, stock) VALUES
    (12, 'Колонка',  'Электроника', 1999, 100),
    (13, 'Подставка','Дом',          499, 300);

-- Обновить
UPDATE products SET stock = stock + 5 WHERE category = 'Дом';

-- Удалить
DELETE FROM products WHERE id = 13;

-- Удалить всё, но быстро (в SQLite TRUNCATE нет — просто DELETE)
DELETE FROM products WHERE id > 12;
```

**Важно:** `UPDATE`/`DELETE` без `WHERE` изменяют **всю таблицу**!

**Попробуй сам:**

```sql
-- Тестово вставим и удалим:
INSERT INTO users (id, name, email, age) VALUES (0, 'Гость', 'guest@example.com', 20);
SELECT * FROM users WHERE id = 0;
DELETE FROM users WHERE id = 0;

-- Bulk insert + проверка
INSERT INTO products (id, name, category, price, stock) VALUES
    (11, 'Мышь',   'Электроника', 1499, 70),
    (12, 'Рюкзак', 'Одежда',      3999, 15);
SELECT name, stock FROM products WHERE id IN (11, 12);
DELETE FROM products WHERE id IN (11, 12);
```

**Задание:** увеличь цену всех товаров «Одежда» на 10%, не испортив остальных.

**Самопроверка:**

```sql
UPDATE products SET price = price * 1.10 WHERE category = 'Одежда';
```

Проверка: `SELECT name, price FROM products WHERE category = 'Одежда';` Новые цены: Футболка 988.9, Джинсы 2858.9, Куртка 8798.9.

---

## DDL и ограничения (constraints)

**DDL** — язык описания данных: `CREATE`, `ALTER`, `DROP`.

```sql
-- Создать таблицу
CREATE TABLE reviews (
    id INTEGER PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products(id),
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    text TEXT
);

-- Добавить колонку
ALTER TABLE reviews ADD COLUMN created_at DATE DEFAULT CURRENT_DATE;

-- Переименовать колонку
ALTER TABLE reviews RENAME COLUMN text TO comment;

-- Удалить колонку (не во всех СУБД)
ALTER TABLE reviews DROP COLUMN comment;

-- Изменить тип (MySQL)
ALTER TABLE users MODIFY COLUMN email VARCHAR(255);

-- Изменить тип (PostgreSQL)
ALTER TABLE users ALTER COLUMN email TYPE VARCHAR(255);

-- Переименовать таблицу
ALTER TABLE reviews RENAME TO feedback;

-- Удалить таблицу
DROP TABLE IF EXISTS reviews;
```

### TRUNCATE

Быстро **очищает все строки** таблицы, сохраняя структуру. В отличие от `DELETE` без `WHERE`: не логируется построчно, не сбрасывает счётчики-триггеры (в некоторых СУБД сбрасывает `AUTO_INCREMENT`), и его нельзя откатить через `ROLLBACK` в MySQL (нельзя в транзакции).

```sql
TRUNCATE TABLE orders;
```

**Ограничения (constraints)** — правила для данных:

| Ограничение | Смысл |
| --- | --- |
| `PRIMARY KEY` | уникальность + не NULL, одна на таблицу |
| `FOREIGN KEY ... REFERENCES` | значение должно существовать в другой таблице |
| `UNIQUE` | уникальность значений |
| `NOT NULL` | запрет пустых значений |
| `CHECK (условие)` | проверка условия при записи |
| `DEFAULT значение` | значение по умолчанию |

**Варианты `ON DELETE` / `ON UPDATE`** (для внешних ключей):

| Опция | Поведение |
| --- | --- |
| `CASCADE` | каскадом удалить/обновить все связанные строки |
| `SET NULL` | установить внешний ключ в `NULL` |
| `SET DEFAULT` | установить значение по умолчанию |
| `RESTRICT` / `NO ACTION` | запретить удаление родителя, пока есть ссылки (по умолчанию) |

```sql
CREATE TABLE orders (
    id INT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(10,2),
    FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE      -- удалили пользователя → удалить его заказы
        -- ON DELETE SET NULL / ON DELETE RESTRICT
);
```

**Составной ключ** — первичный ключ из нескольких колонок, как в `order_items`: `(order_id, product_id)`.

**Автоинкремент** — как不同的 СУБД реализуют автоматическую нумерацию:

| СУБД | Способ |
| --- | --- |
| MySQL | `AUTO_INCREMENT` (атрибут колонки) |
| PostgreSQL | `SERIAL` / `BIGSERIAL` (тип) или `GENERATED ALWAYS AS IDENTITY` |
| SQLite | `INTEGER PRIMARY KEY` (автоматически) |

```sql
-- MySQL
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255)
);

-- PostgreSQL: SERIAL или IDENTITY
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255)
);

-- PostgreSQL: современный способ
CREATE TABLE users (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(255)
);
```

**Попробуй сам:**

```sql
-- Поспешная вставка с нарушением CHECK не пройдёт:
INSERT INTO users (id, name, email, age) VALUES (99, 'Ай', 'a@b.c', 16);
-- → CHECK constraint failed: age >= 18

-- Дубликат e-mail тоже отклонится:
INSERT INTO users (id, name, email, age) VALUES (98, 'Повтор', 'ivanov@example.com', 25);
-- → UNIQUE constraint failed: users.email

-- А несуществующий user_id не вставится (внешний ключ работает,
-- но в SQLite его надо включать: PRAGMA foreign_keys = ON;)
PRAGMA foreign_keys = ON;
INSERT INTO orders (id, user_id, order_date) VALUES (99, 777, '2024-06-01');
-- → FOREIGN KEY constraint failed
```

**Задание:** создай таблицу `discounts` с колонками: `product_id` (внешний ключ на products), `percent` (целое, 1..90), `starts` (дата). Не забудь первичный ключ.

**Самопроверка:**

```sql
CREATE TABLE discounts (
    product_id INTEGER PRIMARY KEY REFERENCES products(id),
    percent INTEGER NOT NULL CHECK (percent BETWEEN 1 AND 90),
    starts DATE
);
```

---

## Нормализация: 1НФ, 2НФ, 3НФ

Нормализация — правила проектирования таблиц, чтобы данные не дублировались и не противоречили друг другу.

**1НФ — атомарность.** В каждой ячейке — одно неделимое значение; строки различимы, нет повторяющихся списков.

```
 ❌ 1НФ нарушена:                     ✅ 1НФ:
 ┌────┬─────────────────┐            ┌────┬─────────┐
 │ id │ name            │            │ id │ name    │
 │ 1  │ Ноутбук, Иван   │            │ 1  │ Ноутбук │
 │ 1  │ Смартфон        │  ← 2 строки│ 2  │ Смартфон│
 └────┴─────────────────┘            └────┴─────────┘
 список «Ноутбук, Иван» — 2 значения
```

**2НФ — нет частичной зависимости.** Каждая неключевая колонка зависит от **всего** составного ключа, а не от его части.

```
 ❌ (key = order_id, product_id)            ✅ разнесли по таблицам
 ┌──────┬─────────┬───────────┐             order_items:
 │ o_id │ p_id    │ p_name    │  p_name     ┌──────┬─────────┐
 │  1   │   1     │ Ноутбук   │  зависит    │ o_id │ p_id    │
 │  1   │   2     │ Ноутбук   │  только от  └──────┴─────────┘
 └──────┴─────────┴───────────┘  p_id(часть) products: p_id,p_name
```

**3НФ — нет транзитивных зависимостей.** Неключевая колонка не должна зависеть от другой неключевой.

```
 ❌ users: id, city_id, city_name, country
    city_name зависит от city_id, а страна от города — транзитивно
 ✅ разделили: users(id, city_id), cities(id, name, country)
```

Демо-база уже нормализована: это и есть 3НФ. `order_items.price` — не нарушение: цена зафиксирована «на момент продажи» и зависит от пары (заказ, товар) целиком.

**Попробуй сам:**

```sql
-- 3НФ в действии: данные не дублируются, название города одно в users
SELECT DISTINCT city FROM users;

-- единственный способ всё сломать — добавить в users лишний город-дубль:
-- (не делай этого, просто запомни: нормализация — это про защиту от такого)
```

**Задание:** предложи в 2-3 предложениях, какую новую таблицу пришлось бы создать, если бы хотелось хранить «несколько адресов пользователя» (сейчас адрес — одна колонка `city`).

**Самопроверка:**

Нужна таблица `addresses (id, user_id, city, street, house)` с внешним ключом `user_id → users.id`. Это связь 1:N: один пользователь — много адресов. Тогда из `users` колонку `city` можно убрать (или оставить «основной» адрес).

Существует и **4НФ**, **5НФ**, **BCNF** — для практики обычно достаточно 3НФ. Иногда нормализацию **намеренно ослабляют** (денормализация): добавляют избыточные столбцы для ускорения тяжёлых чтений (кэширующие суммы и счётчики).

---

## VIEW: виртуальные таблицы

**VIEW** — сохранённый запрос, который ведёт себя как таблица, но данных не хранит: каждый раз выполняется заново.

```sql
CREATE VIEW view_name AS SELECT ...;
SELECT * FROM view_name;
DROP VIEW view_name;
```

**Польза:**

- переиспользуем сложный запрос без копипасты;
- скрываем внутреннюю структуру (продаём «витрину» без кишок);
- даём пользователю только нужные колонки.

**Попробуй сам:**

```sql
-- Витрина «заказ с суммой»
CREATE VIEW v_order_summary AS
SELECT u.name, o.id AS order_id, o.order_date, o.status,
       SUM(oi.quantity * oi.price) AS total
FROM users u
JOIN orders o ON o.user_id = u.id
JOIN order_items oi ON oi.order_id = o.id
GROUP BY u.name, o.id, o.order_date, o.status;

-- Теперь это просто таблица:
SELECT * FROM v_order_summary ORDER BY total DESC;

-- Можно даже строить запросы поверх вьюхи:
SELECT name, MAX(total) AS best_order
FROM v_order_summary
WHERE status = 'completed'
GROUP BY name;

-- Удалить вьюху:
DROP VIEW v_order_summary;
```

**Задание:** создай view `v_popular` — топ товаров по суммарному проданному количеству (из `order_items`), и выбери из неё три строки.

**Самопроверка:**

```sql
CREATE VIEW v_popular AS
SELECT oi.product_id, SUM(oi.quantity) AS sold
FROM order_items oi
GROUP BY oi.product_id
ORDER BY sold DESC;

SELECT * FROM v_popular LIMIT 3;

DROP VIEW v_popular;
```

---

## Оконные функции: ROW_NUMBER, RANK, OVER

Обычные агрегации сворачивают группу в **одну** строку. **Оконные функции** считают значение для **каждой** строки, сохраняя все строки.

Синтаксис:

```sql
Функция() OVER (PARTITION BY колонки_деления ORDER BY колонки_сортировки)
```

- `PARTITION BY` — разрезает строки на «окна» (группы).
- `ORDER BY` внутри OVER — порядок внутри окна.
- `ROW_NUMBER()` — номер строки внутри окна: 1,2,3…
- `RANK()` — номер с пропусками при равенстве: 1,2,2,4.
- `DENSE_RANK()` — номер без пропусков: 1,2,2,3.
- `SUM()/AVG() OVER (...)` — накопительные суммы (running total).

```
 RANK() по колонке X:
 ┌────┬───┬──────┬────────┐
 │ id │ X │ RANK │ DENSE  │
 │ 1  │10 │  1   │   1    │
 │ 2  │10 │  1   │   1    │   ← равенство → одинаковый ранг
 │ 3  │ 8 │  3   │   2    │   ← RANK пропускает 2
 │ 4  │ 5 │  4   │   3    │
 └────┴───┴──────┴────────┘
```

**Попробуй сам:**

```sql
-- Нумерация заказов каждого пользователя по дате
SELECT id, user_id, order_date,
       ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY order_date) AS rn
FROM orders;

-- Рейтинг товаров внутри своей категории по цене
SELECT name, category, price,
       ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) AS pos,
       RANK()       OVER (PARTITION BY category ORDER BY price DESC) AS rk
FROM products
ORDER BY category, price DESC;

-- Накопительная сумма стоимости по дате (running total по всем заказам)
SELECT id, order_date,
       SUM(price * quantity) OVER (ORDER BY order_date, id) AS running_total
FROM (SELECT o.id, o.order_date, oi.quantity, oi.price
      FROM orders o JOIN order_items oi ON oi.order_id = o.id) t;
```

> Примечание: подзапрос в `FROM` нужен, потому что оконная функция видит уже полученные строки `orders join order_items` и при `ORDER BY` не по ключу может понадобиться стабильная сортировка.

**Задание:** выведи для каждого заказа его «порядковый номер» внутри пользователя и одновременно полное число заказов этого пользователя (подсказка: `COUNT(*) OVER (PARTITION BY user_id)`).

**Самопроверка:**

```sql
SELECT id, user_id, order_date,
       ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY order_date) AS nth,
       COUNT(*)      OVER (PARTITION BY user_id) AS total_for_user
FROM orders
ORDER BY user_id, order_date;
```

---

## Проекты-практикумы

Закрепи всё, что изучил, на реальных мини-проектах прямо на демо-базе.

### Проект 1. Отчёт «Кто сколько тратит»

Напиши запрос, который выводит:

1. имя пользователя;
2. количество его заказов;
3. суммарную выручку от его заказов (учитывая `order_items.quantity * order_items.price`);
4. средний чек по всем его заказам;
5. ранжирование по выручке от большего к меньшему.

Подсказка: тебе понадобятся `JOIN`, `GROUP BY`, оконная `SUM` или `RANK`.

**Самопроверка (вариант):**

```sql
SELECT u.name,
       COUNT(DISTINCT o.id) AS orders_cnt,
       SUM(oi.quantity * oi.price) AS revenue,
       ROUND(SUM(oi.quantity * oi.price) / COUNT(DISTINCT o.id), 2) AS avg_order
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
LEFT JOIN order_items oi ON oi.order_id = o.id
GROUP BY u.name
ORDER BY revenue DESC;
```

Обрати внимание на `COUNT(DISTINCT o.id)` — без `DISTINCT` джойн с `order_items` «размножает» заказы.

### Проект 2. Категорийный анализ

Для каждой категории товаров посчитай:

- число товаров;
- сумму остатков на складе (в штуках);
- стоимость склада (price × stock);
- долю категории в общей стоимости склада (%). Долю можно посчитать через подзапрос с `SUM(price*stock)` в знаменателе.

**Самопроверка (вариант):**

```sql
SELECT category,
       COUNT(*) AS cnt,
       SUM(stock) AS units,
       SUM(price * stock) AS value,
       ROUND(100.0 * SUM(price * stock) /
             (SELECT SUM(price * stock) FROM products), 1) AS pct
FROM products
GROUP BY category
ORDER BY value DESC;
```

### Проект 3. Что продаётся лучше всего

Построй топ товаров по выручке (`products` → `order_items`), добавь ранг по выручке и категорию. Выведи только топ-5.

**Самопроверка (вариант):**

```sql
SELECT p.name, p.category,
       SUM(oi.quantity * oi.price) AS revenue,
       RANK() OVER (ORDER BY SUM(oi.quantity * oi.price) DESC) AS pos
FROM products p
JOIN order_items oi ON oi.product_id = p.id
GROUP BY p.name, p.category
ORDER BY pos
LIMIT 5;
```

### Проект 4. Свой мини-отчёт (сложный, но интересный)

Придумай свою метрику. Например:

- «неактивные покупатели»: зарегистрированы, но не сделали ни одного заказа;
- «воронка статусов»: сколько заказов в каждом статусе (`new`, `pending`, `completed`, `cancelled`);
- «глубина заказов»: среднее число позиций в заказе.

Попробуй оформить как отдельный `CREATE VIEW`, затем `SELECT` из неё.

---

## Дополнительные задания (PostgreSQL)

Эти задания используют отдельную схему данных для PostgreSQL.

Учебная схема данных (скопируйте и выполните разом):

```sql
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    age INT CHECK (age >= 0),
    city VARCHAR(100)
);

CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) CHECK (price >= 0)
);

CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    created_at DATE DEFAULT CURRENT_DATE,
    product_id BIGINT REFERENCES products(id),
    quantity INT DEFAULT 1 CHECK (quantity > 0)
);

-- данные
INSERT INTO products (name, category, price) VALUES
('Ноутбук', 'Electronics', 60000),
('Мышь',    'Electronics', 1500),
('Монитор', 'Electronics', 22000),
('Кофеварка','Home',       8000);

-- Выполните и эти строки (у всех пользователей id 1-3)
INSERT INTO users (name, email, age, city) VALUES
('Анна',   'anna@example.com',   25, 'Москва'),
('Борис',  'boris@example.com',  30, 'Москва'),
('Виктор', 'victor@example.com', 19, 'Казань');

INSERT INTO orders (user_id, product_id, quantity) VALUES
(1, 1, 1), (1, 2, 2), (2, 3, 1), (3, 4, 1), (2, 1, 1), (2, 2, 1);
```

### Задание 1. Простой SELECT
Выбрать имя и цену всех товаров дороже 900 рублей.

**Решение:**

```sql
SELECT name, price FROM products WHERE price > 900;
```

### Задание 2. Сортировка и лимит
Вывести 2 самых дорогих товара.

**Решение:**

```sql
SELECT name, price FROM products ORDER BY price DESC LIMIT 2;
```

### Задание 3. Фильтры
Вывести пользователей из Москвы старше 20 лет (все столбцы), отсортированных по имени.

**Решение:**

```sql
SELECT * FROM users
WHERE city = 'Москва' AND age > 20
ORDER BY name;
```

### Задание 4. DISTINCT и IN
Вывести уникальные категории товаров, у которых цена равна 1500, 8000 или 60000.

**Решение:**

```sql
SELECT DISTINCT category FROM products
WHERE price IN (1500, 8000, 60000);
```

### Задание 5. LIKE
Найти пользователей, чья почта заканчивается на `@example.com`, и товары со словом «Ноут» в названии.

**Решение:**

```sql
SELECT name, email FROM users WHERE email LIKE '%@example.com';
SELECT * FROM products WHERE name LIKE '%Ноут%';
```

### Задание 6. Агрегаты
Посчитать общую стоимость всех товаров, среднюю цену, а также минимум и максимум.

**Решение:**

```sql
SELECT SUM(price) AS total,
       AVG(price) AS avg_price,
       MIN(price) AS min_price,
       MAX(price) AS max_price
FROM products;
```

### Задание 7. GROUP BY и HAVING
Для каждой категории посчитать количество товаров и среднюю цену. Оставить только категории с более чем одним товаром.

**Решение:**

```sql
SELECT category, COUNT(*) AS cnt, ROUND(AVG(price), 2) AS avg_price
FROM products
GROUP BY category
HAVING COUNT(*) > 1;
```

### Задание 8. INNER JOIN
Вывести имя пользователя, товар и количество для каждого заказа.

**Решение:**

```sql
SELECT u.name, p.name AS product, o.quantity
FROM orders o
JOIN users u    ON u.id = o.user_id
JOIN products p ON p.id = o.product_id;
```

### Задание 9. LEFT JOIN
Вывести всех пользователей и их общее число заказов. У кого заказов нет — число 0.

**Решение:**

```sql
SELECT u.name, COUNT(o.id) AS orders_cnt
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
GROUP BY u.id, u.name
ORDER BY orders_cnt DESC;
```

### Задание 10. Подзапрос
Вывести товары дороже средней цены по всей таблице.

**Решение:**

```sql
SELECT name, price FROM products
WHERE price > (SELECT AVG(price) FROM products);
```

### Задание 11. CTE
Через CTE найти пользователя (пользователей) с наибольшей общей суммой заказанных товаров. Подсказка: сумма = price × quantity.

**Решение:**

```sql
WITH totals AS (
    SELECT o.user_id, SUM(p.price * o.quantity) AS total
    FROM orders o
    JOIN products p ON p.id = o.product_id
    GROUP BY o.user_id
)
SELECT u.name, t.total
FROM totals t
JOIN users u ON u.id = t.user_id
ORDER BY t.total DESC
LIMIT 1;
```

### Задание 12. Транзакции и COMMIT/ROLLBACK
В транзакции вставьте в `orders` заказ Анны на «Кофеварку» (2 шт). Затем выполните `ROLLBACK` и проверьте, что заказ исчез. Повторите вставку и выполните `COMMIT`.

**Решение:**

```sql
START TRANSACTION;
INSERT INTO orders (user_id, product_id, quantity)
VALUES (1, (SELECT id FROM products WHERE name = 'Кофеварка'), 2);
ROLLBACK;
SELECT * FROM orders;   -- заказа на кофеварку нет

START TRANSACTION;
INSERT INTO orders (user_id, product_id, quantity)
VALUES (1, (SELECT id FROM products WHERE name = 'Кофеварка'), 2);
COMMIT;
SELECT * FROM orders;   -- заказ есть
```

### Задание 13. Индексы и EXPLAIN
Создайте индекс на `orders.user_id` и сравните план выполнения запроса «заказы пользователя А» до и после через `EXPLAIN` (PostgreSQL — `EXPLAIN ANALYZE`).

**Решение:**

```sql
-- до индекса
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = 1;

CREATE INDEX idx_orders_user ON orders (user_id);

-- после индекса: ожидайте Index Scan вместо Seq Scan
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = 1;
```

### Задание 14. Оконная функция
Пронумеруйте заказы в порядке даты (общий порядок, без партиций) и выведите накопительную сумму количества по всем заказам.

**Решение:**

```sql
SELECT o.id, u.name, o.created_at, o.quantity,
       ROW_NUMBER() OVER (ORDER BY o.created_at) AS n,
       SUM(o.quantity) OVER (ORDER BY o.created_at) AS running_qty
FROM orders o
JOIN users u ON u.id = o.user_id
ORDER BY o.created_at;
```

### Задание 15. Нормализация
Дана таблица `orders(id, customer_name, customer_phone, product_name, product_price, qty)`. Нарушает ли она 1НФ/2НФ/3НФ? Спроектируйте нормализованную схему с таблицами `customers`, `products`, `orders`, `order_items`.

**Решение:**

Да, нарушает 2НФ и 3НФ: `customer_name`, `customer_phone` зависят от клиента, а `product_name`, `product_price` — от товара (зависят не от всего ключа и неключевые зависят друг от друга). Схема:

```sql
CREATE TABLE customers (id SERIAL PRIMARY KEY, name TEXT, phone TEXT);
CREATE TABLE products  (id SERIAL PRIMARY KEY, name TEXT, price NUMERIC);
CREATE TABLE orders    (id SERIAL PRIMARY KEY, customer_id INT
                        REFERENCES customers(id), created_at DATE DEFAULT CURRENT_DATE);
CREATE TABLE order_items (order_id INT REFERENCES orders(id),
                          product_id INT REFERENCES products(id),
                          quantity INT, PRIMARY KEY (order_id, product_id));
```

---

## MySQL и PostgreSQL: краткое сравнение

| Критерий | MySQL | PostgreSQL |
| --- | --- | --- |
| Лицензия | Open Source + платные коммерческие версии (Oracle) | Полностью свободная |
| Сильные стороны | Скорость, простота, веб-нагрузки «чтение-heavy» | Сложные запросы, большие БД, расширяемость |
| Соответствие стандарту SQL | Неполное (всегда «быстрее», чем стандарт) | Почти полное (160+ из 179 пунктов) |
| ACID | InnoDB-совместима | Полная совместимость |
| MVCC | Только при движке InnoDB | Встроенная |
| Репликация | master-standby, master-master, круговая | потоковая, логическая, двунаправленная |
| Расширяемость | Ограниченная | Свои типы, функции, индексы, языки |
| Геоданные | Встроенные | Через расширение PostGIS |
| Безопасность | ACL-списки доступа | Роли (ROLE), встроенный SSL |
| GUI | MySQL Workbench | pgAdmin4 |
| Автоинкремент | `AUTO_INCREMENT` | `SERIAL` / `IDENTITY` |
| Один процесс на соединение | Потоки, легче конкуренция | Fork-процесс ~10 МБ на соединение |

Особенности регистра и кавычек (важно для новичка):

- В MySQL сравнение строк без учёта регистра по умолчанию (зависит от collation); в PostgreSQL — чувствительно к регистру.
- MySQL позволяет двойные кавычки для строк, PostgreSQL — только одинарные (двойные — идентификаторы).
- Функции даты: MySQL `NOW()`, `CURDATE()`, `CURTIME()`, `DATE_FORMAT()`; PostgreSQL `CURRENT_TIMESTAMP`, `CURRENT_DATE`, `to_char(..., 'YYYY-MM-DD')`.

**Когда что брать:** MySQL — быстрый веб-стек (магазины, блоги, привычные настройки), PostgreSQL — аналитика, сложные запросы, JSON, расширения, строгий стандарт и большие данные. Как правило, для старта подойдут обе; PostgreSQL рекомендуют чаще из-за полноты функциональности.

---

## Что дальше

- Освойте `EXPLAIN` — он быстрее всего прокачивает понимание запросов.
- Практикуйтесь на SQLite (файл вместо сервера) — минимальный порог входа: `sqlite3 test.db`.
- Дальше: индексы (bitmap, partial, covering), оконные функции, рекурсивные CTE, `JOIN`-оптимизация, миграции, транзакции с уровнями изоляции.

## Литература и ссылки

- SQLite: официальная документация — https://www.sqlite.org/docs.html
- learnsql.com — https://learnsql.com/
- sql-tutorial.ru — практические уроки по SQL (русский) — https://www.sql-tutorial.ru/
- PostgreSQL: официальная документация на русском — https://postgrespro.ru/docs
- MySQL: документация — https://dev.mysql.com/doc/
- ALT Linux Wiki: MySQL — https://www.altlinux.org/MySQL

> Учебник-спутник: **PostgreSQL.md** в этой же папке — практикум с сервером PostgreSQL, JSONB, транзакциями и продакшн-инструментами.