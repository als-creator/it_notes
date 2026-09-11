---
title: Insomnia — Инструкция по применению
source: https://habr.com/ru/articles/754154/
tags:
  - инструменты
  - мануал
---
## Для начинающих специалистов по тестированию

Автор: Надежда Дудник

Заранее хочу сказать, что мне нравится Postman, просто Insomnia часто используемый инструмент для тестирования API у меня на работе, и важно поделиться информацией о его возможностях.

**Содержание:**

- [***Введение***](https://habr.com/ru/articles/754154/#1)
- [***Импорт коллекции***](https://habr.com/ru/articles/754154/#2)
- [***Создание пользователя***](https://habr.com/ru/articles/754154/#3)
- [***Работа с переменными и окружение***](https://habr.com/ru/articles/754154/#3_1)
- [***Авторизация пользователя***](https://habr.com/ru/articles/754154/#4)
- [***Получение токена***](https://habr.com/ru/articles/754154/#4_1)
- [***Создание проекта***](https://habr.com/ru/articles/754154/#5)
	- [***Аутентификация через вкладку "Headers"***](https://habr.com/ru/articles/754154/#5_1)
	- [***Аутентификация через вкладку "Auth"***](https://habr.com/ru/articles/754154/#5_2)
	- [***Дополнение про автоматизацию получения токена для методов, которые требуют токен на предъявителя.***](https://habr.com/ru/articles/754154/#5_2)
- [***Общая информация про Insomnia***](https://habr.com/ru/articles/754154/#6)
- [***Установка сертификата***](https://habr.com/ru/articles/754154/#7)
- [***Возможности автоматизации***](https://habr.com/ru/articles/754154/#8) ***\+ Новая*** [статья Разбор переменных и скриптов в Insomnia](https://habr.com/ru/articles/791826/)
- [***Импорт OpenAPI документации***](https://habr.com/ru/articles/754154/#9)
- [***Создание первого автотеста при создания пользователя***](https://habr.com/ru/articles/754154/#10)
- [***Онлайн-тренажеры и ресурсы***](https://habr.com/ru/articles/754154/#12)
- [***Заключение***](https://habr.com/ru/articles/754154/#11)

## Введение

[Insomnia](https://docs.insomnia.rest/) - инструмент для тестирования REST API (клиент взаимодействия с API)

[Скачать Insomnia](https://insomnia.rest/download)

Для примера я буду использовать мной любимый сайт Vikunja.

UI: [https://try.vikunja.io/login](https://try.vikunja.io/login)

API documentation: [https://try.vikunja.io/api/v1/docs](https://try.vikunja.io/api/v1/docs)

Скачать API Документацию из [https://try.vikunja.io/api/v1/docs](https://try.vikunja.io/api/v1/docs) (найти "Download OpenAPI specification на странице")

## Импорт коллекции

Открыть приложение Insomnia (версия Insomnia.Core-2023.4.0 для Mac / Windows в момент написании статьи). Я буду использовать приложение на Mac.

![Кнопка "Import"](https://habrastorage.org/r/w780/getpro/habr/upload_files/820/d71/f69/820d71f69caf5639e65655cd1b306f4e.png)

Кнопка "Import"

Найти кнопку " **Import** " и нажать на нее. Insomnia предлагает загрузить данные.

![Import to project](https://habrastorage.org/r/w780/getpro/habr/upload_files/218/8de/844/2188de844305dda9e7da4ae390ceaafd.png)

Import to project

Выбрать наш файл docs.json, скачанный из [https://try.vikunja.io/api/v1/docs](https://try.vikunja.io/api/v1/docs)

![Импорт выбранного файла](https://habrastorage.org/r/w780/getpro/habr/upload_files/ea4/8f6/66d/ea48f666de1e8c203ceb69d569d43d0e.png)

Импорт выбранного файла

Нажать на кнопку ***"Scan" -> "Import"***

Коллекция загружена:

![](https://habrastorage.org/r/w780/getpro/habr/upload_files/79c/1d2/a43/79c1d2a435f8755372a3f0ee69c5c1f4.png)

Выбрать коллекцию, и открывается содержимое коллекции:

![](https://habrastorage.org/r/w780/getpro/habr/upload_files/888/b14/96d/888b1496da7e9b74f260af9f8bc70bf5.png)

## Создание пользователя

*Разберу самый первый запрос, который связан с регистрацией пользователя на сайте.*

> *Папка "auth" -> запрос POST Register*

![Папка "auth" -> запрос POST Register](https://habrastorage.org/r/w780/getpro/habr/upload_files/f1c/c05/42f/f1cc0542f83432b5b249d4bc8163619d.png)

Папка "auth" -> запрос POST Register

## Работа с переменными и окружение

Прежде чем разобраться с отправкой самого запроса, проанализирую, а где создать переменную, и где она хранится.

> *В адресной строке для POST запроса отображена переменная ".base\_url".*

Выбрать " ***No Environment*** " в левом верхнем углу

![Выбор "No Environment"  в левом верхнем углу](https://habrastorage.org/r/w780/getpro/habr/upload_files/3aa/7f8/e7e/3aa7f8e7ef83566ebf4ad41cf49620f3.png)

Выбор "No Environment" в левом верхнем углу

Нажать на ***"Manage Environments".***

![](https://habrastorage.org/r/w780/getpro/habr/upload_files/e32/547/e60/e32547e6036fbbeb0b44889e5f9759ae.png)

Нажать на ***"+".***

Указать название новой коллекции "Vikunja", создать переменную ***base\_url*** внести данные как

```json
{"base_url": "https://try.vikunja.io/api/v1"}
```
![Создание переменной base_url](https://habrastorage.org/r/w780/getpro/habr/upload_files/618/797/55c/61879755c8398ebb795b28ec775a5e9f.png)

Создание переменной base\_url

Нажать на кнопку ***"Close".***

**Окружение "Environment" как "Vikunja" выбрано сразу по умолчанию.**

Нажать на "**.base\_url** " в адресной строке -> откроется всплывающее окно для редактирования переменной в окружении.

Проверить, что наше созданное значение **base\_url** имеет следующий вид:

![Всплывающее окно для редактирования переменной в окружении.](https://habrastorage.org/r/w780/getpro/habr/upload_files/40e/6ef/143/40e6ef143127080073ef5d011b1c9635.png)

Всплывающее окно для редактирования переменной в окружении.

Нажать на кнопку *"* ***Done*** *".*

Указать в теле запроса значения на вкладке " ***Body*** -> ***JSON*** ":

```json
{
  "email": "infotestingqa@gmail.com",
  "id": 0,
  "password": "123455",
  "username": "UserName"
}
```
![Тело запроса в формате JSON](https://habrastorage.org/r/w780/getpro/habr/upload_files/bd6/b4d/b90/bd6b4db90b2cb8ca84731e67108016da.png)

Тело запроса в формате JSON

Нажать на кнопку ***"Send"****.* Создан новый пользователь в системе. Ура:)!

![Создание пользователя. Отображение ответа от сервера.](https://habrastorage.org/r/w780/getpro/habr/upload_files/0d1/1bb/d10/0d11bbd10e9dd1a6f1fb6f2e5b313a69.png)

Создание пользователя. Отображение ответа от сервера.

Также есть вкладки " **Auth** ", " **Query** ", '' **Headers** ", " **Docs** ", их я разберу чуть ниже.

## Авторизация пользователя

Далее отправить следующий запрос на авторизацию пользователя

> ***Папка "auth" -> запрос POST Login***

## Получение токена

и получить токен в ответе от сервера.

Согласно [документации](https://try.vikunja.io/api/v1/docs#section/Authorization) используется JWT-Auth: `Authorization: Bearer <jwt-token>.`

Указать в теле запроса значения на вкладке " ***Body*** -> ***JSON*** ":

```json
{
  "long_token": true,
  "password": "123455",
  "totp_passcode": "123455",
  "username": "infotestingqa@gmail.com"
}
```
![Запрос на авторизацию пользователя.](https://habrastorage.org/r/w780/getpro/habr/upload_files/5b1/cd4/b8e/5b1cd4b8eeb3c97b114b6a7e3e5c6abe.png)

Запрос на авторизацию пользователя.

Нажать на кнопку " ***Send*** ". Пользователь авторизован в систему. Получен токен. Ура:)!

![Полученик](https://habrastorage.org/r/w780/getpro/habr/upload_files/ee2/3e4/bbb/ee23e4bbbe8b4303b3d47a59ff9f5412.png)

Получение токена

## Создание проекта

Теперь используем созданный токен в запросе для создания проекта.

Найти папку " ***project*** ", раскрыть ее, выбрать запрос

> ***Папка "project" -> PUT Creates a new project***

![Подготовка к отправке запроса на создание проекта](https://habrastorage.org/r/w780/getpro/habr/upload_files/f3e/449/202/f3e449202620acd8de5f53be635c752b.png)

Подготовка к отправке запроса на создание проекта

Есть два способа, где можно указать переменную для токена (время жизни токена 30 минут или пользователь будет удален из системы через 30 минут).

1. *способ через вкладку "* ***Headers*** *"*
2. *способ через вкладку "* ***Auth*** *"*

***Предусловие****:* Выбрать "Vikunja" окружение в левом верхнем углу -> Выбрать " ***Manage Environments*** " -> Добавить новую переменную c значением:

```json
"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6IiIsImVtYWlsUmVtaW5kZXJzRW5hYmxlZCI6ZmFsc2UsImV4cCI6MTY5MjYyNTE3NSwiaWQiOjIsImlzTG9jYWxVc2VyIjp0cnVlLCJsb25nIjp0cnVlLCJuYW1lIjoiIiwidHlwZSI6MSwidXNlcm5hbWUiOiJVc2VyTmFtZSJ9.QFcn0BDkmh2bF2fpZocxOrUoVVSra8c1cNE9beROYZA"
```
![Добавление новой переменной в окружение](https://habrastorage.org/r/w780/getpro/habr/upload_files/337/3a0/91a/3373a091affa682f117867f678dae921.png)

Добавление новой переменной в окружение

Нажать на кнопку *"* ***Close*** *".*

*\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_*

**Аутентификация через вкладку "Headers"**

Разберем 1 способ через вкладку *"* ***Headers*** *".*

Выбрать вкладку *"* ***Headers*** *".*

![Аутентификация через вкладку "Headers"](https://habrastorage.org/r/w780/getpro/habr/upload_files/2b2/15c/c67/2b215cc67d8bb17e1160ba2158952688.png)

Аутентификация через вкладку "Headers"

Нажать на "***.api\_key*** " -> откроется всплывающее окно для редактирования переменной в окружении.

Отредактировать "***.api\_key*** " на "***.token*** " и нажать на кнопку " ***Done*** "

![Выбор значения token](https://habrastorage.org/r/w780/getpro/habr/upload_files/e1a/bd9/1da/e1abd91da179b2c9fe33a379c3a9b2f3.png)

Выбор значения token

*Установленная переменная имеет вид как "****.token*** *", и в начале обязательно добавить слово "* ***Bearer*** *" и пробел - важно указать для заголовка "Authorization", так как токен на предъявителя.*

![Отображение Bearer _.token](https://habrastorage.org/r/w780/getpro/habr/upload_files/a84/164/7cb/a841647cbbd2f211b780b8b522d0352a.png)

Отображение Bearer \_.token

Отредактировать тело запроса на вкладке "JSON" согласно [требованию](https://try.vikunja.io/api/v1/docs#tag/project/paths/~1projects/put) и нажать на кнопку " ***Send*** ".

В теле запроса указать только название проекта:

```json
{ "title": "my project"}
```
![Создание нового проекта через вкладку "Headers"](https://habrastorage.org/r/w780/getpro/habr/upload_files/436/2df/99c/4362df99cdd4f25108675fc84b6641c3.png)

Создание нового проекта через вкладку "Headers"

*\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_*

**Аутентификация через вкладку "Auth"**

Разберем 2 способ через вкладку " ***Auth*** ".

Выбрать вкладку " ***Auth*** ", нажать на стрелочку вниз (точнее раскрыть) и выбрать тип аутентификации ***"Bearer Token"***

![Аутентификация через вкладку "Auth"](https://habrastorage.org/r/w780/getpro/habr/upload_files/c68/048/7aa/c680487aa14ca2f398fbb93c74e7d1ec.png)

Аутентификация через вкладку "Auth"

Отображается следующий вид:

![Вкладка "Bearer"](https://habrastorage.org/r/w780/getpro/habr/upload_files/092/fba/318/092fba3184521043e605c0ef6aee3cc7.png)

Вкладка "Bearer"

Начать вводить значение ***{{\_*** в поле "TOKEN"

![_.token](https://habrastorage.org/r/w780/getpro/habr/upload_files/78b/67a/d8b/78b67ad8b473df7c22567c696853e2e9.png)

\_.token

и выбрать переменную "***.token*** *".* Нажать на кнопку *"* ***Send*** *".*

![Выбор значение token и отправка запроса на создание проекта.](https://habrastorage.org/r/w780/getpro/habr/upload_files/e4f/cac/01b/e4fcac01bdda9f1d9735a5f2163de340.png)

Выбор значение token и отправка запроса на создание проекта.

Создан новый проект! Ура!)

![Создание нового проекта через вкладку "Auth"](https://habrastorage.org/r/w780/getpro/habr/upload_files/de3/d8f/ff0/de3d8fff06c76249932d355578e9089d.png)

Создание нового проекта через вкладку "Auth"

***Дополнение про автоматизацию получения токена для методов, которые требуют токен на предъявителя.***

***Предусловие****:* Выбрать "Vikunja" окружение в левом верхнем углу -> Выбрать " ***Manage Environments*** " -> Добавить новую переменную c значением:

```javascript
Request -> OAuth 2.0 Access Token
```
![Автоматизация получения токена для методов, которые требуют токен на предъявителя](https://habrastorage.org/r/w780/getpro/habr/upload_files/996/277/eab/996277eab38870c8989086a1736a7bc2.png)

Автоматизация получения токена для методов, которые требуют токен на предъявителя

После того как выбрано данное значение будет следующий вид:

![Выбор Request -> OAuth 2.0 Access Token](https://habrastorage.org/r/w780/getpro/habr/upload_files/936/f08/db0/936f08db0b996569a2e6a39fb3532df2.png)

Выбор Request -> OAuth 2.0 Access Token

Нажать на ***{% request 'oauth2', '', 0 %}***

![Редактирование переменной](https://habrastorage.org/r/w780/getpro/habr/upload_files/b06/ac3/bbf/b06ac3bbfc19e7afa32a17c169ff8107.png)

Редактирование переменной

Далее выполнить конфигурацию, выбрать *"* ***Response - reference values from other request's responses*** *"*

![Выбор "Response - reference values from other request's responses"](https://habrastorage.org/r/w780/getpro/habr/upload_files/ebf/bc4/4c9/ebfbc44c90362daa9264554dfd1c294d.png)

Выбор "Response - reference values from other request's responses"

Будет отображено следующее окно, данные поля важно заполнить следующими значениями:

1. Атрибут - значение из тела ответа от сервера
2. Запрос - авторизация пользователя " ***POST Login*** "
3. Указать конкретный ключ, начиная с ***$.***, а именно ***$.token***, и в " ***Live Preview*** " сразу отображается значение токена.
4. Trigger Behavior говорит о том, что когда токен затухает, то еще раз отправить запрос на авторизацию пользователя
5. Можно нажать на " ***Refresh*** ", токен обновится
6. Нажать на " ***Done*** "
![Внесение необходимых данных](https://habrastorage.org/r/w780/getpro/habr/upload_files/be5/e8e/f41/be5e8ef41e9a69c36675d47fb5029ede.png)

Внесение необходимых данных

Будет отображаться следующее окно*,* ***ВАЖНО указать значение токена в кавычках****!*

```javascript
"token": "Response -> Body Attribute"
```

сама команда выглядит так:

```javascript
"token": "{% response 'body', 'req_d2e9a976eb4d4e6595011784f232df4a', 'b64::JC50b2tlbg==::46b', 'when-expired', 60 %}"
```
!["token": "Response -> Body Attribute"](https://habrastorage.org/r/w780/getpro/habr/upload_files/d9c/72a/cdd/d9c72acddb8ccf551d0482f992906961.png)

"token": "Response -> Body Attribute"

Закрыть окно *"* ***Manage Environments*** *".*

Выбрать вкладку " ***Auth*** ", нажать на стрелочку вниз (точнее раскрыть) и выбрать тип аутентификации " ***Bearer Token*** ". Начать вводить значение ***{{*** в поле " ***TOKEN*** " и выбрать переменную "***.token*** ". Нажать на кнопку " ***Send*** ".

![Отображение необходимых данных](https://habrastorage.org/r/w780/getpro/habr/upload_files/92c/cb0/491/92ccb049150c9560aa949f630a6e94a9.png)

Отображение необходимых данных

Ура! Проект создан! Главное не забываем создать пользователя, авторизоваться в систему, и токен таким способом будет получаться автоматически.

Для других запросов можно также "вытащить" необходимые значения.

## Общая информация про Insomnia

**Insomnia поддерживает отправку запросов через HTTP, gRPC, GraphQL, WebSocket.**

![Отправка запросов через HTTP, gRPC, GraphQL, WebSocket.](https://habrastorage.org/r/w780/getpro/habr/upload_files/7f1/121/26a/7f112126a1fa741b21e9f2103cae9ff2.png)

Отправка запросов через HTTP, gRPC, GraphQL, WebSocket.

**для HTTP request:**

Вкладки " ***Body*** " (указание тела запроса), " ***Auth*** " (указание типа авторизации), " ***Query*** " (указание параметров), '' ***Headers*** " (указание HTTP заголовков запроса), " ***Docs*** " (указание документации OpenApi для запроса

![для HTTP request](https://habrastorage.org/r/w780/getpro/habr/upload_files/3b7/2ad/faa/3b72adfaa9c98ae2e3dae61423d528ee.png)

для HTTP request

![Выбор формата передачи данных JSON](https://habrastorage.org/r/w780/getpro/habr/upload_files/814/153/31d/81415331d9e44e1a229ff4759b8f2955.png)

Выбор формата передачи данных JSON

**Для запроса можно сделать следующие действия:**

![Действия с запросом](https://habrastorage.org/r/w780/getpro/habr/upload_files/924/2f4/bca/9242f4bcacd6f259a51a2c1ad9872342.png)

Действия с запросом

Особенно важная функция как **" *Generate Code* "**.

**Для HTTP response:**

Вкладки " ***Preview or Source or Raw*** " (указание тела ответа от сервера), '' ***Headers*** " (указание HTTP заголовков ответа), " ***Cookies*** ", " ***Timeline*** " (информация про временные особенности)

**Например, *Timeline* после отправки запроса на создание проекта**

> *Preparing request to* [*https://try.vikunja.io/api/v1/projects*](https://try.vikunja.io/api/v1/projects)
> 
> *Current time is 2023-07-22T21:30:46.171Z*
> 
> *Enable automatic URL encoding*
> 
> *Using default HTTP version*
> 
> *Enable SSL validation*
> 
> *Too old connection (567 seconds), disconnect it*
> 
> и т.д.

![Параметра для ответа от сервера](https://habrastorage.org/r/w780/getpro/habr/upload_files/dd3/0ca/755/dd30ca7550b748e6a27bec34aa072cdf.png)

Параметра для ответа от сервера

## Установка сертификата

Про установку сертификата (например, для финтеха это самое первое, что нужно сделать прежде чем отправить запрос).

![](https://habrastorage.org/r/w780/getpro/habr/upload_files/951/36f/93d/95136f93d35acc3468ef1fcd9f2921d1.png)

Выбрать " ***Collection Settings*** " -> " ***Client Certificates*** ". Нажать на " ***New Certificate*** ".

![Окно Добавления сертификата](https://habrastorage.org/r/w780/getpro/habr/upload_files/c12/adc/973/c12adc9734527b4902d4674820828c95.png)

Окно Добавления сертификата

Все необходимые файлы и хосты должны предоставить коллеги (админы, спросите в общем чате).

Указать " ***Host*** ", нажать на " ***Choose Cert*** " и " ***Choose Key*** ", добавить файлы.

![Заполнение окна для сертификата](https://habrastorage.org/r/w780/getpro/habr/upload_files/728/2eb/67b/7282eb67b6faf5a8e29e91470243b726.png)

Заполнение окна для сертификата

Нажать на кнопку *"* ***Create Certificate*** *"*

Режим просмотра:

![Отображение внесенных данных, сертификат выбран по умолчанию.](https://habrastorage.org/r/w780/getpro/habr/upload_files/13b/67a/c70/13b67ac70b205aa6fa84d3548e0a36ca.png)

Отображение внесенных данных, сертификат выбран по умолчанию.

Для нашей работы в настройках запроса убрать галочки в чек-боксах " ***Send cookies automatically*** " и " ***Store cookies automatically*** ":

![](https://habrastorage.org/r/w780/getpro/habr/upload_files/25c/4ee/233/25c4ee2332fe2a84861393345e75ba42.png)

## Возможности автоматизации

Инструмент позволяет сделать тестовые сценарии: негативные и позитивные, используется язык JS для автоматизации, позволяет проводить прогоны и получать отчет прогона и сформировать CI для автозапуска из консоли.

## Импорт OpenAPI документации

Я решила обновить статью (январь, 2025г.), так как приложение уже сильно обновили новыми фичами.

Скрины ниже для

Version: Insomnia 10.3.0  
Build date: 20.12.2024  
OS: Windows\_NT x64 10.0.19045  
Architecture: x64

Нажать на иконку **" *Домашняя страница* " -> *Найти "All File* s" -> " *Documents* " ->** Нажать **на "+"**

![Импорт Open API документации](https://habrastorage.org/r/w780/getpro/habr/upload_files/196/99d/618/19699d6187850d335902f8fe0962abd4.png)

Импорт Open API документации

Импорт Open API документацииСистема отображает всплывающее окно " ***Create New Design Document*** ", оставить " *my-spec.yaml* " и нажать на кнопку " ***Create*** "

![my-spec.yaml](https://habrastorage.org/r/w780/getpro/habr/upload_files/71c/f28/d9a/71cf28d9a65ecb5dbaa651902ac48af3.png)

my-spec.yaml

Создан New Document. Отображены три вкладки **"SPEC", "COLLECTION", "TESTS".**

![Создан New Document, ОБРАТИТЬ ВНИМАНИЕ на Import OpenAPI](https://habrastorage.org/r/w780/getpro/habr/upload_files/3a5/919/8a7/3a59198a7161c03f8c4047046d736a21.png)

Создан New Document, ОБРАТИТЬ ВНИМАНИЕ на Import OpenAPI

Нажать на кнопку **" *Import OpenAPI* " ->** Выбрать **"Import *File* ".**

Выбрать наш файл docs.json, скачанный из [https://try.vikunja.io/api/v1/docs](https://try.vikunja.io/api/v1/docs)

![Отображение Open API документации](https://habrastorage.org/r/w780/getpro/habr/upload_files/723/2dd/389/7232dd389c827e6f0527a35022dbffe3.png)

Отображение Open API документации

**Отображена документация "Vikunja API".**

## Создание первого автотеста при создания пользователя

Выбрать вкладку " ***COLLECTION*** " - > Добавить запрос на создание пользователя->

![Регистрация нового пользователя](https://habrastorage.org/r/w780/getpro/habr/upload_files/390/5b1/acf/3905b1acff7bc450572f82c0132ca931.png)

Регистрация нового пользователя

Предупреждаю, что при повторном создании пользователя необходимо изменить почту и имя пользователя.

Так как я уже создала пользователя, то для автотеста я изменю значения почты и имени для пользователя.

Выбрать вкладку " ***TESTS*** " - > Найти и нажать **"+ *New Test* "** \->

![](https://habrastorage.org/r/w780/getpro/habr/upload_files/65d/d5a/cfa/65dd5acfa0381a1f82042b04a3ac02ed.png)

Указать название " ***Tests*** " -> Нажать на кнопку " ***New Test Suite*** "

![](https://habrastorage.org/r/w780/getpro/habr/upload_files/e71/3b5/67a/e713b567a8d4905de9347cf058298df8.png)

Нажать на кнопку " **+** ***New Test*** " -> Оставить дефолтное название " ***Returns 200*** " (так как при создании пользователя возвращается статус код 200)

![](https://habrastorage.org/r/w780/getpro/habr/upload_files/b32/226/b1f/b32226b1ffef93164048a327ad9cdf00.png)

Выбрать dropdown " ***Select Request*** " -> Выбрать наш запрос на "Создание пользователя (регистрация)" из вкладки "COLLECTION"

![](https://habrastorage.org/r/w780/getpro/habr/upload_files/908/9ed/e44/9089ede442b9a3a5edaaa4b123b6ac06.png)

Insomnia предлагает дефолтный фрагмент кода:

```javascript
const response1 = await insomnia.send();
expect(response1.status).to.equal(200);
```
![](https://habrastorage.org/r/w780/getpro/habr/upload_files/772/e82/efd/772e82efd34a17040015022516be3576.png)

Нажать на кнопку *"* ***Run tests*** *".*

![Статус указан "Passed"](https://habrastorage.org/r/w780/getpro/habr/upload_files/f83/e17/199/f83e171990d4a1ebbf0e1649ca8e133e.png)

Статус указан " Passed "

"Успешно выполнен тест, статус указан " **Passed** "*.*

Повторно нажать на кнопку " ***Run Tests*** ".

![статус указан "Failed"](https://habrastorage.org/r/w780/getpro/habr/upload_files/dac/8a3/389/dac8a3389559d238a0140e676641ba7b.png)

статус указан " Failed "

Тест провален, статус указан " **Failed** ".

Ура, написан простейший автотест.

**Еще примеры:**

Предусловия: изменены почта и имя пользователя на вкладке "COLLECTION"

![](https://habrastorage.org/r/w780/getpro/habr/upload_files/2e4/b51/098/2e4b51098d0fec85a91abd57ff2b4eb3.png)

Добавлены два теста на отправку регистрации пользователя "Response body has property Id" и ''Response body is json object". Каждый раз отправляется новый тест, поэтому второй тест будет отображать ошибку, что такой пользователь существует (для этого случая будет создан новый тест "User already exists".

![](https://habrastorage.org/r/w780/getpro/habr/upload_files/036/e47/a5e/036e47a5e76a59b8ad73990c0d1a5747.png)

***Код для тренировки:***

**1 тест " *Response body has property Id* "**

```javascript
const response1 = await insomnia.send();
const body = JSON.parse(response1.data);
const item = body;
expect(item).to.have.property("id");
```

**2 тест '' *Response body is json object* "**

```javascript
const response1 = await insomnia.send();
const resp_body = JSON.parse(response1.data);
expect(resp_body).to.be.an('object');
```

**3 тест на проверку, что такой пользователь существует (" *User already exists* ").**

![Тест на проверку, что пользователь уже существует в системе](https://habrastorage.org/r/w780/getpro/habr/upload_files/f1c/882/797/f1c882797a579295f98c26f8acf9ea0a.png)

Тест на проверку, что пользователь уже существует в системе

```javascript
const response1 = await insomnia.send();
expect(response1.status).to.equal(400);
const body = JSON.parse(response1.data);
const item = body;
expect(item).to.have.property("code");
expect(item).to.have.property("message");
```

Больше информации про скрипты в [официальной документации](https://docs.insomnia.rest/insomnia/unit-testing).

## Онлайн-тренажеры и ресурсы

Площадки для изучения Insomnia и REST API:

| Ресурс | Описание |
| --- | --- |
| [Insomnia Documentation](https://docs.insomnia.rest/) | Официальная документация Insomnia — полный справочник. |
| [Insomnia Hub](https://insomnia.rest/hub) | Каталог шаблонов API и коллекций запросов от сообщества. |
| [JSONPlaceholder](https://jsonplaceholder.typicode.com/) | Бесплатный fake REST API для экспериментов с HTTP-запросами. |
| [Reqres](https://reqres.in/) | Бесплатный тестовый REST API для фронтенда и тестирования. |
| [Postman Echo](https://docs.postman-echo.com/) | Echo-сервис Postman для отладки HTTP-запросов. |
| [HTTPstatuses](https://httpstatuses.com/) | Справочник HTTP-статус-кодов с описаниями. |

## Заключение

Есть такие возможности у Insomnia: встроенный DevTools, конвертация запроса в код, JSON|XML - читабельный вид (Beautify JSON), есть подсказки на валидацию введенных значений, история запросов. Также убедились, что есть возможность настроить окружение, создавать динамические переменные и тест-кейсы и прогонять их. Конечно, есть и минусы в запуске тест-кейсов, и все же этот инструмент становится лучше и обновляется.

***Благодарю за прочтение.***

***С уважением, Надежда Дудник (***[***protestinginfo***](https://t.me/protestinginfo)***)***, главный инженер по тестированию в финтехе и ментор по тестированию ПО.
