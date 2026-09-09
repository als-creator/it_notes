> **Git** — распределённая система контроля версий: она записывает каждое изменение файлов и позволяет в любой момент вернуться к любой версии проекта. Это стандарт-де-факто для разработки: всё — от личных скриптов до ядра Linux — хранится именно так.

### С чего начать новичку

Шпаргалка построена **от простого к сложному** — просто идите по разделам сверху вниз, команду можно пробовать сразу в любом репозитории:

1.  **Базовые понятия** — как Git устроен (5 минут теории);
2.  **Настройка Git** — имя, email, редактор (один раз);
3.  **Создание/клонирование** — как появиться проект;
4.  **Ежедневная работа** — `add` → `commit` — этот цикл и есть 80% работы;
5.  **История** (`git log`) — смотреть, что уже сделано;
6.  **Отмена изменений** — как исправить ошибку;
7.  **Ветвление** — самая мощная (и нестрашная!) часть Git;
8.  **Удалённые репозитории** — GitHub/GitLab, `push`/`pull`, SSH-ключи;
9.  Дальше — по вкусу: теги, `.gitignore`, `gh`, `lazygit`, продвинутые инструменты.

## Содержание

- [С чего начать новичку](#%D1%81-%D1%87%D0%B5%D0%B3%D0%BE-%D0%BD%D0%B0%D1%87%D0%B0%D1%82%D1%8C-%D0%BD%D0%BE%D0%B2%D0%B8%D1%87%D0%BA%D1%83)
- [Базовые понятия](#%D0%B1%D0%B0%D0%B7%D0%BE%D0%B2%D1%8B%D0%B5-%D0%BF%D0%BE%D0%BD%D1%8F%D1%82%D0%B8%D1%8F)
    - [Три состояния файлов](#%D1%82%D1%80%D0%B8-%D1%81%D0%BE%D1%81%D1%82%D0%BE%D1%8F%D0%BD%D0%B8%D1%8F-%D1%84%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2)
    - [Указатели](#%D1%83%D0%BA%D0%B0%D0%B7%D0%B0%D1%82%D0%B5%D0%BB%D0%B8)
    - [Относительная адресация](#%D0%BE%D1%82%D0%BD%D0%BE%D1%81%D0%B8%D1%82%D0%B5%D0%BB%D1%8C%D0%BD%D0%B0%D1%8F-%D0%B0%D0%B4%D1%80%D0%B5%D1%81%D0%B0%D1%86%D0%B8%D1%8F)
- [Настройка Git](#%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B9%D0%BA%D0%B0-git)
    - [Глобальная конфигурация](#%D0%B3%D0%BB%D0%BE%D0%B1%D0%B0%D0%BB%D1%8C%D0%BD%D0%B0%D1%8F-%D0%BA%D0%BE%D0%BD%D1%84%D0%B8%D0%B3%D1%83%D1%80%D0%B0%D1%86%D0%B8%D1%8F)
    - [Windows: преобразование окончаний строк](#windows-%D0%BF%D1%80%D0%B5%D0%BE%D0%B1%D1%80%D0%B0%D0%B7%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5-%D0%BE%D0%BA%D0%BE%D0%BD%D1%87%D0%B0%D0%BD%D0%B8%D0%B9-%D1%81%D1%82%D1%80%D0%BE%D0%BA)
    - [Алиасы (сокращения)](#%D0%B0%D0%BB%D0%B8%D0%B0%D1%81%D1%8B-%D1%81%D0%BE%D0%BA%D1%80%D0%B0%D1%89%D0%B5%D0%BD%D0%B8%D1%8F)
    - [Готовый файл ~/.gitconfig](#%D0%B3%D0%BE%D1%82%D0%BE%D0%B2%D1%8B%D0%B9-%D1%84%D0%B0%D0%B9%D0%BB-gitconfig)
- [Создание и клонирование репозитория](#%D1%81%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5-%D0%B8-%D0%BA%D0%BB%D0%BE%D0%BD%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5-%D1%80%D0%B5%D0%BF%D0%BE%D0%B7%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D1%8F)
    - [git init — создать репозиторий](#git-init--%D1%81%D0%BE%D0%B7%D0%B4%D0%B0%D1%82%D1%8C-%D1%80%D0%B5%D0%BF%D0%BE%D0%B7%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D0%B9)
    - [git clone — копия удалённого репозитория](#git-clone--%D0%BA%D0%BE%D0%BF%D0%B8%D1%8F-%D1%83%D0%B4%D0%B0%D0%BB%D1%91%D0%BD%D0%BD%D0%BE%D0%B3%D0%BE-%D1%80%D0%B5%D0%BF%D0%BE%D0%B7%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D1%8F)
- [Ежедневная работа: status / add / commit](#%D0%B5%D0%B6%D0%B5%D0%B4%D0%BD%D0%B5%D0%B2%D0%BD%D0%B0%D1%8F-%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D0%B0-status--add--commit)
    - [git status — состояние проекта](#git-status--%D1%81%D0%BE%D1%81%D1%82%D0%BE%D1%8F%D0%BD%D0%B8%D0%B5-%D0%BF%D1%80%D0%BE%D0%B5%D0%BA%D1%82%D0%B0)
    - [git add — добавить изменения в индекс](#git-add--%D0%B4%D0%BE%D0%B1%D0%B0%D0%B2%D0%B8%D1%82%D1%8C-%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D1%8F-%D0%B2-%D0%B8%D0%BD%D0%B4%D0%B5%D0%BA%D1%81)
    - [git rm — удалить файл](#git-rm--%D1%83%D0%B4%D0%B0%D0%BB%D0%B8%D1%82%D1%8C-%D1%84%D0%B0%D0%B9%D0%BB)
    - [git commit — фиксация изменений](#git-commit--%D1%84%D0%B8%D0%BA%D1%81%D0%B0%D1%86%D0%B8%D1%8F-%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B9)
    - [git diff — различия](#git-diff--%D1%80%D0%B0%D0%B7%D0%BB%D0%B8%D1%87%D0%B8%D1%8F)
- [История коммитов: log / show / blame / reflog](#%D0%B8%D1%81%D1%82%D0%BE%D1%80%D0%B8%D1%8F-%D0%BA%D0%BE%D0%BC%D0%BC%D0%B8%D1%82%D0%BE%D0%B2-log--show--blame--reflog)
    - [git log — история коммитов](#git-log--%D0%B8%D1%81%D1%82%D0%BE%D1%80%D0%B8%D1%8F-%D0%BA%D0%BE%D0%BC%D0%BC%D0%B8%D1%82%D0%BE%D0%B2)
    - [git show — содержимое коммита](#git-show--%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B8%D0%BC%D0%BE%D0%B5-%D0%BA%D0%BE%D0%BC%D0%BC%D0%B8%D1%82%D0%B0)
    - [git blame — кто написал строку](#git-blame--%D0%BA%D1%82%D0%BE-%D0%BD%D0%B0%D0%BF%D0%B8%D1%81%D0%B0%D0%BB-%D1%81%D1%82%D1%80%D0%BE%D0%BA%D1%83)
    - [git reflog — история перемещений HEAD («чёрный ящик»)](#git-reflog--%D0%B8%D1%81%D1%82%D0%BE%D1%80%D0%B8%D1%8F-%D0%BF%D0%B5%D1%80%D0%B5%D0%BC%D0%B5%D1%89%D0%B5%D0%BD%D0%B8%D0%B9-head-%D1%87%D1%91%D1%80%D0%BD%D1%8B%D0%B9-%D1%8F%D1%89%D0%B8%D0%BA)
    - [git grep — поиск по проекту](#git-grep--%D0%BF%D0%BE%D0%B8%D1%81%D0%BA-%D0%BF%D0%BE-%D0%BF%D1%80%D0%BE%D0%B5%D0%BA%D1%82%D1%83)
- [Отмена изменений: reset / revert / stash / clean](#%D0%BE%D1%82%D0%BC%D0%B5%D0%BD%D0%B0-%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B9-reset--revert--stash--clean)
    - [git reset — откат истории (ТОЛЬКО для неопубликованных коммитов)](#git-reset--%D0%BE%D1%82%D0%BA%D0%B0%D1%82-%D0%B8%D1%81%D1%82%D0%BE%D1%80%D0%B8%D0%B8-%D1%82%D0%BE%D0%BB%D1%8C%D0%BA%D0%BE-%D0%B4%D0%BB%D1%8F-%D0%BD%D0%B5%D0%BE%D0%BF%D1%83%D0%B1%D0%BB%D0%B8%D0%BA%D0%BE%D0%B2%D0%B0%D0%BD%D0%BD%D1%8B%D1%85-%D0%BA%D0%BE%D0%BC%D0%BC%D0%B8%D1%82%D0%BE%D0%B2)
    - [git revert — безопасная отмена (для опубликованных коммитов)](#git-revert--%D0%B1%D0%B5%D0%B7%D0%BE%D0%BF%D0%B0%D1%81%D0%BD%D0%B0%D1%8F-%D0%BE%D1%82%D0%BC%D0%B5%D0%BD%D0%B0-%D0%B4%D0%BB%D1%8F-%D0%BE%D0%BF%D1%83%D0%B1%D0%BB%D0%B8%D0%BA%D0%BE%D0%B2%D0%B0%D0%BD%D0%BD%D1%8B%D1%85-%D0%BA%D0%BE%D0%BC%D0%BC%D0%B8%D1%82%D0%BE%D0%B2)
    - [git stash — временное хранилище](#git-stash--%D0%B2%D1%80%D0%B5%D0%BC%D0%B5%D0%BD%D0%BD%D0%BE%D0%B5-%D1%85%D1%80%D0%B0%D0%BD%D0%B8%D0%BB%D0%B8%D1%89%D0%B5)
    - [git clean — удаление неотслеживаемых файлов](#git-clean--%D1%83%D0%B4%D0%B0%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5-%D0%BD%D0%B5%D0%BE%D1%82%D1%81%D0%BB%D0%B5%D0%B6%D0%B8%D0%B2%D0%B0%D0%B5%D0%BC%D1%8B%D1%85-%D1%84%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2)
    - [git checkout -- — отмена изменений в файле](#git-checkout-----%D0%BE%D1%82%D0%BC%D0%B5%D0%BD%D0%B0-%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B9-%D0%B2-%D1%84%D0%B0%D0%B9%D0%BB%D0%B5)
- [Ветвление и слияние](#%D0%B2%D0%B5%D1%82%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5-%D0%B8-%D1%81%D0%BB%D0%B8%D1%8F%D0%BD%D0%B8%D0%B5)
    - [git branch — работа с ветками](#git-branch--%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D0%B0-%D1%81-%D0%B2%D0%B5%D1%82%D0%BA%D0%B0%D0%BC%D0%B8)
    - [git checkout / git switch — переключение](#git-checkout--git-switch--%D0%BF%D0%B5%D1%80%D0%B5%D0%BA%D0%BB%D1%8E%D1%87%D0%B5%D0%BD%D0%B8%D0%B5)
    - [git merge — слияние](#git-merge--%D1%81%D0%BB%D0%B8%D1%8F%D0%BD%D0%B8%D0%B5)
    - [git rebase — линейная история](#git-rebase--%D0%BB%D0%B8%D0%BD%D0%B5%D0%B9%D0%BD%D0%B0%D1%8F-%D0%B8%D1%81%D1%82%D0%BE%D1%80%D0%B8%D1%8F)
    - [git cherry-pick — копирование коммитов](#git-cherry-pick--%D0%BA%D0%BE%D0%BF%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5-%D0%BA%D0%BE%D0%BC%D0%BC%D0%B8%D1%82%D0%BE%D0%B2)
    - [git commit --amend — исправить последний коммит (до push)](#git-commit---amend--%D0%B8%D1%81%D0%BF%D1%80%D0%B0%D0%B2%D0%B8%D1%82%D1%8C-%D0%BF%D0%BE%D1%81%D0%BB%D0%B5%D0%B4%D0%BD%D0%B8%D0%B9-%D0%BA%D0%BE%D0%BC%D0%BC%D0%B8%D1%82-%D0%B4%D0%BE-push)
- [Удалённые репозитории: remote / push / pull / fetch](#%D1%83%D0%B4%D0%B0%D0%BB%D1%91%D0%BD%D0%BD%D1%8B%D0%B5-%D1%80%D0%B5%D0%BF%D0%BE%D0%B7%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D0%B8-remote--push--pull--fetch)
    - [git remote — управление удалёнными репозиториями](#git-remote--%D1%83%D0%BF%D1%80%D0%B0%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5-%D1%83%D0%B4%D0%B0%D0%BB%D1%91%D0%BD%D0%BD%D1%8B%D0%BC%D0%B8-%D1%80%D0%B5%D0%BF%D0%BE%D0%B7%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D1%8F%D0%BC%D0%B8)
    - [git push — отправить изменения](#git-push--%D0%BE%D1%82%D0%BF%D1%80%D0%B0%D0%B2%D0%B8%D1%82%D1%8C-%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D1%8F)
    - [git pull — забрать и слить](#git-pull--%D0%B7%D0%B0%D0%B1%D1%80%D0%B0%D1%82%D1%8C-%D0%B8-%D1%81%D0%BB%D0%B8%D1%82%D1%8C)
    - [git fetch — забрать, но НЕ сливать](#git-fetch--%D0%B7%D0%B0%D0%B1%D1%80%D0%B0%D1%82%D1%8C-%D0%BD%D0%BE-%D0%BD%D0%B5-%D1%81%D0%BB%D0%B8%D0%B2%D0%B0%D1%82%D1%8C)
- [GitHub: доступ по HTTPS отключён → настраиваем SSH](#github-%D0%B4%D0%BE%D1%81%D1%82%D1%83%D0%BF-%D0%BF%D0%BE-https-%D0%BE%D1%82%D0%BA%D0%BB%D1%8E%D1%87%D1%91%D0%BD--%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%B0%D0%B8%D0%B2%D0%B0%D0%B5%D0%BC-ssh)
    - [Как выглядит ошибка при попытке доступа по HTTPS](#%D0%BA%D0%B0%D0%BA-%D0%B2%D1%8B%D0%B3%D0%BB%D1%8F%D0%B4%D0%B8%D1%82-%D0%BE%D1%88%D0%B8%D0%B1%D0%BA%D0%B0-%D0%BF%D1%80%D0%B8-%D0%BF%D0%BE%D0%BF%D1%8B%D1%82%D0%BA%D0%B5-%D0%B4%D0%BE%D1%81%D1%82%D1%83%D0%BF%D0%B0-%D0%BF%D0%BE-https)
    - [Проверка текущего доступа (какой протокол использует ваш ПК)](#%D0%BF%D1%80%D0%BE%D0%B2%D0%B5%D1%80%D0%BA%D0%B0-%D1%82%D0%B5%D0%BA%D1%83%D1%89%D0%B5%D0%B3%D0%BE-%D0%B4%D0%BE%D1%81%D1%82%D1%83%D0%BF%D0%B0-%D0%BA%D0%B0%D0%BA%D0%BE%D0%B9-%D0%BF%D1%80%D0%BE%D1%82%D0%BE%D0%BA%D0%BE%D0%BB-%D0%B8%D1%81%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D1%83%D0%B5%D1%82-%D0%B2%D0%B0%D1%88-%D0%BF%D0%BA)
    - [Полная настройка SSH-ключа на новом ПК](#%D0%BF%D0%BE%D0%BB%D0%BD%D0%B0%D1%8F-%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B9%D0%BA%D0%B0-ssh-%D0%BA%D0%BB%D1%8E%D1%87%D0%B0-%D0%BD%D0%B0-%D0%BD%D0%BE%D0%B2%D0%BE%D0%BC-%D0%BF%D0%BA)
    - [Перенастроить конкретный репозиторий с HTTPS на SSH](#%D0%BF%D0%B5%D1%80%D0%B5%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B8%D1%82%D1%8C-%D0%BA%D0%BE%D0%BD%D0%BA%D1%80%D0%B5%D1%82%D0%BD%D1%8B%D0%B9-%D1%80%D0%B5%D0%BF%D0%BE%D0%B7%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D0%B9-%D1%81-https-%D0%BD%D0%B0-ssh)
    - [Перенастроить весь ПК: сетевой протокол для gh CLI и новых клонов](#%D0%BF%D0%B5%D1%80%D0%B5%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B8%D1%82%D1%8C-%D0%B2%D0%B5%D1%81%D1%8C-%D0%BF%D0%BA-%D1%81%D0%B5%D1%82%D0%B5%D0%B2%D0%BE%D0%B9-%D0%BF%D1%80%D0%BE%D1%82%D0%BE%D0%BA%D0%BE%D0%BB-%D0%B4%D0%BB%D1%8F-gh-cli-%D0%B8-%D0%BD%D0%BE%D0%B2%D1%8B%D1%85-%D0%BA%D0%BB%D0%BE%D0%BD%D0%BE%D0%B2)
    - [Для HTTPS-тока (если SSH по каким-то причинам невозможен)](#%D0%B4%D0%BB%D1%8F-https-%D1%82%D0%BE%D0%BA%D0%B0-%D0%B5%D1%81%D0%BB%D0%B8-ssh-%D0%BF%D0%BE-%D0%BA%D0%B0%D0%BA%D0%B8%D0%BC-%D1%82%D0%BE-%D0%BF%D1%80%D0%B8%D1%87%D0%B8%D0%BD%D0%B0%D0%BC-%D0%BD%D0%B5%D0%B2%D0%BE%D0%B7%D0%BC%D0%BE%D0%B6%D0%B5%D0%BD)
- [SSH-ключи для удалённого сервера (не GitHub)](#ssh-%D0%BA%D0%BB%D1%8E%D1%87%D0%B8-%D0%B4%D0%BB%D1%8F-%D1%83%D0%B4%D0%B0%D0%BB%D1%91%D0%BD%D0%BD%D0%BE%D0%B3%D0%BE-%D1%81%D0%B5%D1%80%D0%B2%D0%B5%D1%80%D0%B0-%D0%BD%D0%B5-github)
    - [Быстрый способ: ssh-copy-id (рекомендуется)](#%D0%B1%D1%8B%D1%81%D1%82%D1%80%D1%8B%D0%B9-%D1%81%D0%BF%D0%BE%D1%81%D0%BE%D0%B1-ssh-copy-id-%D1%80%D0%B5%D0%BA%D0%BE%D0%BC%D0%B5%D0%BD%D0%B4%D1%83%D0%B5%D1%82%D1%81%D1%8F)
    - [Ручной способ (если ssh-copy-id нет)](#%D1%80%D1%83%D1%87%D0%BD%D0%BE%D0%B9-%D1%81%D0%BF%D0%BE%D1%81%D0%BE%D0%B1-%D0%B5%D1%81%D0%BB%D0%B8-ssh-copy-id-%D0%BD%D0%B5%D1%82)
    - [Проверка подключения](#%D0%BF%D1%80%D0%BE%D0%B2%D0%B5%D1%80%D0%BA%D0%B0-%D0%BF%D0%BE%D0%B4%D0%BA%D0%BB%D1%8E%D1%87%D0%B5%D0%BD%D0%B8%D1%8F)
    - [Файл ~/.ssh/config для удобства](#%D1%84%D0%B0%D0%B9%D0%BB-sshconfig-%D0%B4%D0%BB%D1%8F-%D1%83%D0%B4%D0%BE%D0%B1%D1%81%D1%82%D0%B2%D0%B0)
    - [Отключить парольный вход (после проверки, что ключи работают)](#%D0%BE%D1%82%D0%BA%D0%BB%D1%8E%D1%87%D0%B8%D1%82%D1%8C-%D0%BF%D0%B0%D1%80%D0%BE%D0%BB%D1%8C%D0%BD%D1%8B%D0%B9-%D0%B2%D1%85%D0%BE%D0%B4-%D0%BF%D0%BE%D1%81%D0%BB%D0%B5-%D0%BF%D1%80%D0%BE%D0%B2%D0%B5%D1%80%D0%BA%D0%B8-%D1%87%D1%82%D0%BE-%D0%BA%D0%BB%D1%8E%D1%87%D0%B8-%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D0%B0%D1%8E%D1%82)
- [Алиасы SSH в ~/.ssh/config](#%D0%B0%D0%BB%D0%B8%D0%B0%D1%81%D1%8B-ssh-%D0%B2-sshconfig)
    - [Базовая запись для одного хоста](#%D0%B1%D0%B0%D0%B7%D0%BE%D0%B2%D0%B0%D1%8F-%D0%B7%D0%B0%D0%BF%D0%B8%D1%81%D1%8C-%D0%B4%D0%BB%D1%8F-%D0%BE%D0%B4%D0%BD%D0%BE%D0%B3%D0%BE-%D1%85%D0%BE%D1%81%D1%82%D0%B0)
    - [Несколько алиасов на один сервер + туннели (пример с вашей машины)](#%D0%BD%D0%B5%D1%81%D0%BA%D0%BE%D0%BB%D1%8C%D0%BA%D0%BE-%D0%B0%D0%BB%D0%B8%D0%B0%D1%81%D0%BE%D0%B2-%D0%BD%D0%B0-%D0%BE%D0%B4%D0%B8%D0%BD-%D1%81%D0%B5%D1%80%D0%B2%D0%B5%D1%80--%D1%82%D1%83%D0%BD%D0%BD%D0%B5%D0%BB%D0%B8-%D0%BF%D1%80%D0%B8%D0%BC%D0%B5%D1%80-%D1%81-%D0%B2%D0%B0%D1%88%D0%B5%D0%B9-%D0%BC%D0%B0%D1%88%D0%B8%D0%BD%D1%8B)
    - [Маски, общие настройки и продвинутые опции](#%D0%BC%D0%B0%D1%81%D0%BA%D0%B8-%D0%BE%D0%B1%D1%89%D0%B8%D0%B5-%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B9%D0%BA%D0%B8-%D0%B8-%D0%BF%D1%80%D0%BE%D0%B4%D0%B2%D0%B8%D0%BD%D1%83%D1%82%D1%8B%D0%B5-%D0%BE%D0%BF%D1%86%D0%B8%D0%B8)
- [Теги](#%D1%82%D0%B5%D0%B3%D0%B8)
- [Файлы .gitignore и .gitattributes](#%D1%84%D0%B0%D0%B9%D0%BB%D1%8B-gitignore-%D0%B8-gitattributes)
    - [.gitignore — какие файлы игнорировать](#gitignore--%D0%BA%D0%B0%D0%BA%D0%B8%D0%B5-%D1%84%D0%B0%D0%B9%D0%BB%D1%8B-%D0%B8%D0%B3%D0%BD%D0%BE%D1%80%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D1%82%D1%8C)
    - [Если забыли добавить файлы в .gitignore после коммита](#%D0%B5%D1%81%D0%BB%D0%B8-%D0%B7%D0%B0%D0%B1%D1%8B%D0%BB%D0%B8-%D0%B4%D0%BE%D0%B1%D0%B0%D0%B2%D0%B8%D1%82%D1%8C-%D1%84%D0%B0%D0%B9%D0%BB%D1%8B-%D0%B2-gitignore-%D0%BF%D0%BE%D1%81%D0%BB%D0%B5-%D0%BA%D0%BE%D0%BC%D0%BC%D0%B8%D1%82%D0%B0)
    - [.gitattributes — нормализация переносов и diff](#gitattributes--%D0%BD%D0%BE%D1%80%D0%BC%D0%B0%D0%BB%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D1%8F-%D0%BF%D0%B5%D1%80%D0%B5%D0%BD%D0%BE%D1%81%D0%BE%D0%B2-%D0%B8-diff)
- [GitHub CLI (gh)](#github-cli-gh)
- [lazygit](#lazygit)
    - [Установка](#%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0)
    - [Интерфейс](#%D0%B8%D0%BD%D1%82%D0%B5%D1%80%D1%84%D0%B5%D0%B9%D1%81)
    - [Основные горячие клавиши](#%D0%BE%D1%81%D0%BD%D0%BE%D0%B2%D0%BD%D1%8B%D0%B5-%D0%B3%D0%BE%D1%80%D1%8F%D1%87%D0%B8%D0%B5-%D0%BA%D0%BB%D0%B0%D0%B2%D0%B8%D1%88%D0%B8)
    - [Работа с ветками](#%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D0%B0-%D1%81-%D0%B2%D0%B5%D1%82%D0%BA%D0%B0%D0%BC%D0%B8)
    - [Commit и push](#commit-%D0%B8-push)
    - [Squash, rebase, force-push](#squash-rebase-force-push)
    - [Конфигурация](#%D0%BA%D0%BE%D0%BD%D1%84%D0%B8%D0%B3%D1%83%D1%80%D0%B0%D1%86%D0%B8%D1%8F)
    - [Лучшие практики](#%D0%BB%D1%83%D1%87%D1%88%D0%B8%D0%B5-%D0%BF%D1%80%D0%B0%D0%BA%D1%82%D0%B8%D0%BA%D0%B8)
- [Визуальные Git-клиенты (open source)](#%D0%B2%D0%B8%D0%B7%D1%83%D0%B0%D0%BB%D1%8C%D0%BD%D1%8B%D0%B5-git-%D0%BA%D0%BB%D0%B8%D0%B5%D0%BD%D1%82%D1%8B-open-source)
    - [Встроенные: gitk и git-gui](#%D0%B2%D1%81%D1%82%D1%80%D0%BE%D0%B5%D0%BD%D0%BD%D1%8B%D0%B5-gitk-%D0%B8-git-gui)
    - [tig — TUI-клиент в терминале](#tig--tui-%D0%BA%D0%BB%D0%B8%D0%B5%D0%BD%D1%82-%D0%B2-%D1%82%D0%B5%D1%80%D0%BC%D0%B8%D0%BD%D0%B0%D0%BB%D0%B5)
    - [Git Cola — лёгкий GUI](#git-cola--%D0%BB%D1%91%D0%B3%D0%BA%D0%B8%D0%B9-gui)
    - [GitAhead — современный GUI (Qt)](#gitahead--%D1%81%D0%BE%D0%B2%D1%80%D0%B5%D0%BC%D0%B5%D0%BD%D0%BD%D1%8B%D0%B9-gui-qt)
    - [lazygit — уже разобран выше](#lazygit--%D1%83%D0%B6%D0%B5-%D1%80%D0%B0%D0%B7%D0%BE%D0%B1%D1%80%D0%B0%D0%BD-%D0%B2%D1%8B%D1%88%D0%B5)
- [Продвинутые инструменты](#%D0%BF%D1%80%D0%BE%D0%B4%D0%B2%D0%B8%D0%BD%D1%83%D1%82%D1%8B%D0%B5-%D0%B8%D0%BD%D1%81%D1%82%D1%80%D1%83%D0%BC%D0%B5%D0%BD%D1%82%D1%8B)
    - [git bisect — поиск сломавшего коммита](#git-bisect--%D0%BF%D0%BE%D0%B8%D1%81%D0%BA-%D1%81%D0%BB%D0%BE%D0%BC%D0%B0%D0%B2%D1%88%D0%B5%D0%B3%D0%BE-%D0%BA%D0%BE%D0%BC%D0%BC%D0%B8%D1%82%D0%B0)
    - [git worktree — несколько рабочих директорий](#git-worktree--%D0%BD%D0%B5%D1%81%D0%BA%D0%BE%D0%BB%D1%8C%D0%BA%D0%BE-%D1%80%D0%B0%D0%B1%D0%BE%D1%87%D0%B8%D1%85-%D0%B4%D0%B8%D1%80%D0%B5%D0%BA%D1%82%D0%BE%D1%80%D0%B8%D0%B9)
    - [git submodule — вложенные репозитории](#git-submodule--%D0%B2%D0%BB%D0%BE%D0%B6%D0%B5%D0%BD%D0%BD%D1%8B%D0%B5-%D1%80%D0%B5%D0%BF%D0%BE%D0%B7%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D0%B8)
    - [git lfs — большие файлы](#git-lfs--%D0%B1%D0%BE%D0%BB%D1%8C%D1%88%D0%B8%D0%B5-%D1%84%D0%B0%D0%B9%D0%BB%D1%8B)
    - [git archive — архив проекта](#git-archive--%D0%B0%D1%80%D1%85%D0%B8%D0%B2-%D0%BF%D1%80%D0%BE%D0%B5%D0%BA%D1%82%D0%B0)
    - [Переписывание истории / очистка](#%D0%BF%D0%B5%D1%80%D0%B5%D0%BF%D0%B8%D1%81%D1%8B%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5-%D0%B8%D1%81%D1%82%D0%BE%D1%80%D0%B8%D0%B8--%D0%BE%D1%87%D0%B8%D1%81%D1%82%D0%BA%D0%B0)
    - [git format-patch / git apply — передача изменений патчами](#git-format-patch--git-apply--%D0%BF%D0%B5%D1%80%D0%B5%D0%B4%D0%B0%D1%87%D0%B0-%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B9-%D0%BF%D0%B0%D1%82%D1%87%D0%B0%D0%BC%D0%B8)
    - [Git Hooks — автоматизация проверок](#git-hooks--%D0%B0%D0%B2%D1%82%D0%BE%D0%BC%D0%B0%D1%82%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D1%8F-%D0%BF%D1%80%D0%BE%D0%B2%D0%B5%D1%80%D0%BE%D0%BA)
- [Командная работа: workflow и best practices](#%D0%BA%D0%BE%D0%BC%D0%B0%D0%BD%D0%B4%D0%BD%D0%B0%D1%8F-%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D0%B0-workflow-%D0%B8-best-practices)
    - [Git Flow, GitHub Flow и Trunk-Based](#git-flow-github-flow-%D0%B8-trunk-based)
    - [Conventional Commits и именование веток](#conventional-commits-%D0%B8-%D0%B8%D0%BC%D0%B5%D0%BD%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5-%D0%B2%D0%B5%D1%82%D0%BE%D0%BA)
    - [Code review и защита веток](#code-review-%D0%B8-%D0%B7%D0%B0%D1%89%D0%B8%D1%82%D0%B0-%D0%B2%D0%B5%D1%82%D0%BE%D0%BA)
- [Платформы для хостинга Git-репозиториев](#%D0%BF%D0%BB%D0%B0%D1%82%D1%84%D0%BE%D1%80%D0%BC%D1%8B-%D0%B4%D0%BB%D1%8F-%D1%85%D0%BE%D1%81%D1%82%D0%B8%D0%BD%D0%B3%D0%B0-git-%D1%80%D0%B5%D0%BF%D0%BE%D0%B7%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D0%B5%D0%B2)
    - [GitHub Actions и CI/CD](#github-actions-%D0%B8-cicd)
- [Git на собеседованиях (частые вопросы)](#git-%D0%BD%D0%B0-%D1%81%D0%BE%D0%B1%D0%B5%D1%81%D0%B5%D0%B4%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F%D1%85-%D1%87%D0%B0%D1%81%D1%82%D1%8B%D0%B5-%D0%B2%D0%BE%D0%BF%D1%80%D0%BE%D1%81%D1%8B)
- [GitHub Pages](#github-pages)
- [Тренажёры и практика](#%D1%82%D1%80%D0%B5%D0%BD%D0%B0%D0%B6%D1%91%D1%80%D1%8B-%D0%B8-%D0%BF%D1%80%D0%B0%D0%BA%D1%82%D0%B8%D0%BA%D0%B0)
- [Практические рецепты](#%D0%BF%D1%80%D0%B0%D0%BA%D1%82%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B8%D0%B5-%D1%80%D0%B5%D1%86%D0%B5%D0%BF%D1%82%D1%8B)
    - [Начало работы: новый репозиторий + первый коммит + push](#%D0%BD%D0%B0%D1%87%D0%B0%D0%BB%D0%BE-%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D1%8B-%D0%BD%D0%BE%D0%B2%D1%8B%D0%B9-%D1%80%D0%B5%D0%BF%D0%BE%D0%B7%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D0%B9--%D0%BF%D0%B5%D1%80%D0%B2%D1%8B%D0%B9-%D0%BA%D0%BE%D0%BC%D0%BC%D0%B8%D1%82--push)
    - [Быстрый универсальный цикл работы с репозиторием](#%D0%B1%D1%8B%D1%81%D1%82%D1%80%D1%8B%D0%B9-%D1%83%D0%BD%D0%B8%D0%B2%D0%B5%D1%80%D1%81%D0%B0%D0%BB%D1%8C%D0%BD%D1%8B%D0%B9-%D1%86%D0%B8%D0%BA%D0%BB-%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D1%8B-%D1%81-%D1%80%D0%B5%D0%BF%D0%BE%D0%B7%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D0%B5%D0%BC)
    - [Очистка истории коммитов (запушить «с чистого листа»)](#%D0%BE%D1%87%D0%B8%D1%81%D1%82%D0%BA%D0%B0-%D0%B8%D1%81%D1%82%D0%BE%D1%80%D0%B8%D0%B8-%D0%BA%D0%BE%D0%BC%D0%BC%D0%B8%D1%82%D0%BE%D0%B2-%D0%B7%D0%B0%D0%BF%D1%83%D1%88%D0%B8%D1%82%D1%8C-%D1%81-%D1%87%D0%B8%D1%81%D1%82%D0%BE%D0%B3%D0%BE-%D0%BB%D0%B8%D1%81%D1%82%D0%B0)
    - [Синхронизация форка с мастер-репозиторием](#%D1%81%D0%B8%D0%BD%D1%85%D1%80%D0%BE%D0%BD%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D1%8F-%D1%84%D0%BE%D1%80%D0%BA%D0%B0-%D1%81-%D0%BC%D0%B0%D1%81%D1%82%D0%B5%D1%80-%D1%80%D0%B5%D0%BF%D0%BE%D0%B7%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D0%B5%D0%BC)
    - [Изменение автора во всех коммитах (filter-branch)](#%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-%D0%B0%D0%B2%D1%82%D0%BE%D1%80%D0%B0-%D0%B2%D0%BE-%D0%B2%D1%81%D0%B5%D1%85-%D0%BA%D0%BE%D0%BC%D0%BC%D0%B8%D1%82%D0%B0%D1%85-filter-branch)
    - [Создание пустого репозитория на сервере](#%D1%81%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5-%D0%BF%D1%83%D1%81%D1%82%D0%BE%D0%B3%D0%BE-%D1%80%D0%B5%D0%BF%D0%BE%D0%B7%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D1%8F-%D0%BD%D0%B0-%D1%81%D0%B5%D1%80%D0%B2%D0%B5%D1%80%D0%B5)
    - [Вернуться к состоянию до слияния (откат merge)](#%D0%B2%D0%B5%D1%80%D0%BD%D1%83%D1%82%D1%8C%D1%81%D1%8F-%D0%BA-%D1%81%D0%BE%D1%81%D1%82%D0%BE%D1%8F%D0%BD%D0%B8%D1%8E-%D0%B4%D0%BE-%D1%81%D0%BB%D0%B8%D1%8F%D0%BD%D0%B8%D1%8F-%D0%BE%D1%82%D0%BA%D0%B0%D1%82-merge)
    - [Запушить без запроса логина/пароля (HTTPS)](#%D0%B7%D0%B0%D0%BF%D1%83%D1%88%D0%B8%D1%82%D1%8C-%D0%B1%D0%B5%D0%B7-%D0%B7%D0%B0%D0%BF%D1%80%D0%BE%D1%81%D0%B0-%D0%BB%D0%BE%D0%B3%D0%B8%D0%BD%D0%B0%D0%BF%D0%B0%D1%80%D0%BE%D0%BB%D1%8F-https)
- [Полезные ресурсы](#%D0%BF%D0%BE%D0%BB%D0%B5%D0%B7%D0%BD%D1%8B%D0%B5-%D1%80%D0%B5%D1%81%D1%83%D1%80%D1%81%D1%8B)

* * *

## Тренажёры и практика

Интерактивные тренажёры и игры для отработки Git без риска что-то сломать в рабочих репозиториях. Подходят и новичкам, и тем, кто хочет освоить ветвление/реbase/cherry-pick на практике.

- **Тур по Git** — интерактивный курс на русском с реальным терминалом в браузере, живой визуализацией графа коммитов/веток и сертификатом по итогу: 5 модулей (основы, ветвление, история, удалённые репозитории, продвинутый), 59 уроков, 39 упражнений: https://git-tour.zzet.org/ru
- **AKlimenko School — Git-тренажёр** — интерактивные задачи и песочница по веткам, merge, rebase, reset и cherry-pick (ориентирован и на QA-специалистов): https://aklimenkoschool.ru/simulators/git-tasks/
- **Хекслет — Основы Git** — бесплатный структурированный курс на русском: 15 уроков, 14 тестов и 13 упражнений на тренажёре + 4 испытания. Хорош как системный «первый проход» с теорией: https://ru.hexlet.io/courses/intro_to_git
- **GitByBit** — интерактивный курс на русском прямо в редакторе кода: реальный Git и терминал, 48 уроков, 28 команд, мгновенная проверка и тесты. Основной курс бесплатный (PRO — командная работа): https://gitbybit.com/ru
- **Learn Git Branching** — визуальный тренажёр ветвления, merge/rebase/cherry-pick, интерактивные уровни с подсказками: https://learngitbranching.js.org/?locale=ru_RU
- **Oh My Git!** — виртуальная игра-песочница с карточными механиками, полный русский перевод: https://ohmygit.org
- **GitHub Skills** — официальные мини-курсы от GitHub прямо в репозитории (интерфейс на русском): https://skills.github.com
- **Visualizing Git** — наглядная визуализация того, что происходит с графом коммитов при каждой команде: https://git-school.github.io/visualizing-git
- **Gitexercises** — конвейер реальных заданий в терминале (имитируют рабочие задачи, прогресс хранится у вас): https://gitexercises.fracz.com
- **Повторение через git log** — если хочется «бить по клавишам» без интернета, проще всего создать пустой репозиторий и повторять команды из раздела [Практические рецепты](#%D0%BF%D1%80%D0%B0%D0%BA%D1%82%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B8%D0%B5-%D1%80%D0%B5%D1%86%D0%B5%D0%BF%D1%82%D1%8B)

> Совет: начните с Learn Git Branching (быстро даёт картинку ветвления), затем Oh My Git! — чтобы закрепить, и только потом GitHub Skills для реального рабочего сценария (fork → ветка → PR → merge).

* * *

## Базовые понятия

Git — распределённая система контроля версий, созданная Линусом Торвальдсом в 2005 году для управления ядром Linux. Каждый разработчик получает **полную копию репозитория** со всей историей, поэтому можно работать офлайн, создавать ветки мгновенно и не зависеть от сервера.

### Три состояния файлов

Любой файл в репозитории проходит через три «дерева»:

- **Рабочая директория** — файлы, с которыми вы работаете на диске.
- **Индекс (staging area)** — список отслеживаемых изменений, готовых к следующему коммиту.
- **Директория `.git/`** — всё хранилище версий: коммиты, ветки, теги, история.

Отслеживаемые файлы могут находиться в трёх состояниях: **неизменённые**, **изменённые**, **проиндексированные** (готовые к коммиту).

```text
   ФАЙЛЫ НА ДИСКЕ        ИНДЕКС (staging)        ХРАНИЛИЩЕ (.git)
   рабочая директория     «зона подготовки»        коммиты, ветки, теги
 ┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐
 │  modified, new   │   │  проиндексирован │   │  коммит         │
 │  deleted         │   │  (готов к        │   │  (снимок: файлы │
 │  untracked       │   │   коммиту)       │   │   + метаданные) │
 └────────┬────────┘   └────────┬────────┘   └────────┬────────┘
          │ git add             │ git commit           │
          └────────────────────►└──────────────────────┘

  файл изменён  →  git add  →  файл проиндексирован  →  git commit  →  сохранено
  файл изменён  ←──────────────── git reset ──────────────────────────────┘
```

### Указатели

- **`HEAD`** — указатель на текущий коммит (или ветку).
- **`ORIG_HEAD`** — коммит, с которого вы только что переместили HEAD (например, командой `git reset`).
- **Ветка** — перемещающийся указатель на коммит.
- **Тег** — неподвижный указатель на коммит.
- **Коммит** — неизменяемое «сохранение» набора изменений. У коммитов (кроме первого) есть один или несколько родительских коммитов.

```text
   main (ветка = подвижный указатель)          HEAD
     │                                         ┌──────┐
     │                                         │ main │ ← указывает сюда
     ▼                                         └──────┘
    c3 ◄──────────────────────────────────────────┘
    │
    c2 ◄── тег v1.0 (неподвижный указатель)
    │
    c1 ◄── первый коммит (нет родителя)

  Ветка ДВИГАЕТСЯ вперёд с каждым коммитом на main.
  Тег ОСТАЁТСЯ на месте навсегда — удобно для релизов.
```

### Относительная адресация

| Запись | Что означает |
| --- | --- |
| `HEAD` | последний коммит активной ветки |
| `HEAD~1` / `HEAD^` / `@~` | предыдущий коммит |
| `HEAD~2` / `HEAD^^` | два коммита назад |
| `HEAD~2^` | комбинирование адресации |

* * *

## Настройка Git

### Глобальная конфигурация

```bash
git config --global user.name "Ваше Имя"
git config --global user.email "you@example.com"

# Ветка по умолчанию для новых репозиториев — main
git config --global init.defaultBranch main

# Редактор для сообщений коммитов и rebase
git config --global core.editor "code --wait"

# Цветной вывод
git config --global color.ui auto

# Не спрашивать пароль для HTTPS повторно
git config --global credential.helper cache

# Показать текущую конфигурацию
git config --list
```

Используйте `--local` вместо `--global`, чтобы задать конфигурацию только для конкретного проекта.

### Windows: преобразование окончаний строк

```bash
git config --global core.autocrlf true   # CRLF → LF при коммите
```

### Алиасы (сокращения)

```bash
git config --global alias.st status   # git st
git config --global alias.co checkout # git co
git config --global alias.br branch   # git br
git config --global alias.lg "log --graph --oneline" # красивый лог
```

### Готовый файл `~/.gitconfig`

```ini
[user]
    name = Ваше Имя
    email = you@example.com
[init]
    defaultBranch = main
[core]
    quotepath = false
    pager = less -r
    editor = nano -ixO -r72
[push]
    default = simple
[color "status"]
    added = green bold
    changed = yellow bold
    untracked = red bold
```

* * *

## Создание и клонирование репозитория

### `git init` — создать репозиторий

```bash
git init              # создать новый репозиторий в текущей директории (папка .git)
git init folder-name  # создать в указанной директории
git init --bare       # создать «пустой» серверный репозиторий (без рабочей копии)
```

### `git clone` — копия удалённого репозитория

```bash
git clone https://github.com/user/project.git        # в одноимённую папку
git clone https://github.com/user/project.git Folder # в папку Folder
git clone https://github.com/user/project.git .      # в текущую папку
git clone --recursive URL                            # вместе с подмодулями
git clone ssh://user@host:port/~user/repository      # по SSH

# Импорт SVN-репозитория (-s — стандартные папки trunk, branches, tags)
git svn clone -s http://repo/location
```

* * *

## Ежедневная работа: status / add / commit

Это три основные команды, покрывающие 80% ежедневной работы.

```text
  ЕЖЕДНЕВНЫЙ ЦИКЛ:
  ┌──────────┐  git add   ┌──────────┐  git commit  ┌──────────┐
  │  РЕДАКТИР│───────────►│  ПРОСМОТР│─────────────►│  СОХРАНЕНИЕ│
  │  (измене-│            │  (staging)│              │  (коммит) │
  │  ния)    │            │           │              │           │
  └──────────┘            └──────────┘              └──────────┘
       │                                                       │
       └──── git status показывает: что изменено, что добавлено
             git diff  показывает: ЧТО именно изменилось
```

### `git status` — состояние проекта

```bash
git status   # показать изменённые, новые и проиндексированные файлы
```

### `git add` — добавить изменения в индекс

```bash
git add .            # все изменения в текущей директории и поддиректориях
git add file.txt     # конкретный файл
git add -p           # интерактивно по частям (hunks)
git add -i           # интерактивная оболочка выбора файлов
```

### `git rm` — удалить файл

```bash
git rm file.txt        # удалить отслеживаемый файл и проиндексировать удаление
git rm -f file.txt     # удалить изменённый файл (принудительно)
git rm -r log/         # удалить всю директорию
git rm --cached file   # убрать из отслеживания, ФАЙЛ ОСТАНЕТСЯ НА МЕСТЕ (часто для .gitignore)
```

### `git commit` — фиксация изменений

```bash
git commit                         # открыть редактор для сообщения
git commit -m "Сообщение"          # коммит с сообщением
git commit -a -m "Сообщение"       # проиндексировать ОТСЛЕЖИВАЕМЫЕ файлы и закоммитить (новые файлы НЕ добавятся)
git commit -s -m "Сообщение"       # + sign-off (DCO)
git commit -c ORIG_HEAD            # коммит, переиспользуя сообщение из ORIG_HEAD (с редактированием)
git commit -C ORIG_HEAD            # то же, но без редактирования сообщения
```

**Хорошее сообщение коммита** — атомарное: заголовок до 50–72 символов («что сделано») и тело через пустую строку («почему»). Плохо: `fix`. Хорошо: `fix: prevent crash when user has no avatar`.

### `git diff` — различия

```bash
git diff                  # рабочая директория и индекс
git diff --cached         # (или --staged) индекс и HEAD
git diff HEAD             # рабочая директория и последний коммит
git diff HEAD~1           # с предыдущим коммитом
git diff main feature     # две ветки
git diff a1b2c3d e4f5g6h  # два коммита
git diff --staged         # подготовленные изменения
git diff --stat           # краткая сводка по файлам
git diff --name-only      # только имена файлов
```

* * *

## История коммитов: log / show / blame / reflog

### `git log` — история коммитов

```bash
git log                  # полная история активной ветки
git log --oneline        # компактно (хеш + сообщение)
git log -2               # последние 2 коммита
git log -p               # с изменениями по строкам
git log --stat           # со статистикой изменений
git log --summary        # сведения о создании/переименовании файлов
git log --graph --oneline --all   # ASCII-граф всех веток (красиво)
git log --since=2.weeks  # за последние 2 недели
git log --after '2018-06-30'  # после указанной даты
git log --grep fix       # коммиты, где в описании есть «fix»
git log --grep 'fix' -i  # регистронезависимо
git log file.txt         # история конкретного файла
git log -p file.txt      # история файла с изменениями
git log master..branch_99    # коммиты branch_99, не влитые в master
git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short  # красивый формат
git log --pretty=oneline  # по коммиту в строку
```

Выход из длинного лога: клавиша `q`.

### `git show` — содержимое коммита

```bash
git show a1b2c3d          # изменения из конкретного коммита
git show HEAD~            # данные предыдущего коммита
git show @~:file.txt      # содержимое файла на предыдущем коммите
```

### `git blame` — кто написал строку

```bash
git blame README.md                 # автор и коммит для каждой строки
git blame README.md --date=short -L 5,8   # только строки 5–8
git blame -L 2,+3 README            # 3 строки со 2-й
```

### `git reflog` — история перемещений HEAD («чёрный ящик»)

Хранит историю перемещений HEAD (90 дней для достижимых коммитов, 30 — для недостижимых). Даже «потерянный» после reset/rebase коммит можно восстановить.

```bash
git reflog                 # показать историю действий
git reflog -20             # последние 20 изменений HEAD
git reflog feature -2      # лог перемещений ветки feature
git reset --hard feature@{1}  # вернуться к состоянию до нужного действия
```

### `git grep` — поиск по проекту

```bash
git grep tst          # искать «tst» в проекте
git grep tst v1       # искать в старой версии (теге)
git grep -c tst       # подсчитать вхождения
```

* * *

## Отмена изменений: reset / revert / stash / clean

### `git reset` — откат истории (ТОЛЬКО для неопубликованных коммитов)

Три режима определяют судьбу файлов:

- `--soft` — коммит убирается, изменения остаются в staging.
- `--mixed` (по умолчанию) — коммит убирается, изменения остаются в рабочей директории.
- `--hard` — коммит убирается, **все изменения удаляются** (необратимо!).
- `--keep` — безопаснее `--hard`: не потеряет изменения в рабочей директории.

```text
  git reset передвигает HEAD назад и решает, что делать с изменениями:

                    рабочий каталог     staging      история (HEAD)
  --soft            изменения остаются   изменения      коммит убран
                    (не тронуто)         ОСТАЮТСЯ        ← HEAD сдвинут назад

  --mixed (по      изменения ОСТАЮТСЯ   staging ОЧИЩЕН  коммит убран
  умолчанию)                                                   
  --hard            изменения УДАЛЕНЫ    удалено        коммит убран
                                                          (необратимо)
```

```bash
git reset                 # убрать из индекса все добавленные изменения (антипод git add)
git reset file.txt        # убрать из индекса изменения конкретного файла
git reset --soft HEAD~1   # отменить последний коммит, сохранив изменения в staging
git reset --soft @~2      # на 2 коммита назад, сохраняя изменения
git reset --hard          # вернуть состояние HEAD, удалив незакоммиченные изменения
git reset --hard @~       # передвинуть HEAD на предыдущий коммит
git reset --hard 75e2d51  # передвинуть HEAD на коммит с хешем
git reset --keep @~       # сбросить индекс, но сохранить изменения в рабочей директории
```

### `git revert` — безопасная отмена (для опубликованных коммитов)

Создаёт новый коммит, отменяющий указанный, **не переписывая историю**.

```bash
git revert HEAD --no-edit       # отменить последний коммит
git revert a1b2c3d --no-edit    # отменить конкретный коммит по хешу
git revert cgsjd2h -m 1         # отменить коммит слияния (указать родителя)
```

### `git stash` — временное хранилище

```bash
git stash             # спрятать незакоммиченные изменения
git stash list        # список записей
git stash pop         # вернуть последние изменения и удалить из stash
git stash apply       # применить без удаления из stash
git stash apply stash@{1}  # применить конкретную запись
```

### `git clean` — удаление неотслеживаемых файлов

```bash
git clean -n   # пробный запуск (показать, что будет удалено)
git clean -fd  # удалить неотслеживаемые файлы и директории
```

### `git checkout --` — отмена изменений в файле

```bash
git checkout -- file.txt       # вернуть файл к состоянию в индексе
git checkout f26ed88 -- file   # восстановить файл из конкретного коммита
```

* * *

## Ветвление и слияние

### `git branch` — работа с ветками

```bash
git branch                # список локальных веток (активная помечена *)
git branch -a             # все ветки, включая удалённые
git branch -r             # только удалённые ветки
git branch -v             # список веток с последним коммитом
git branch new-branch     # создать ветку
git branch -d new-branch  # удалить слитую ветку
git branch -D new-branch  # удалить ветку принудительно
git branch -m new-name    # переименовать текущую ветку
git branch -m old new     # переименовать ветку old в new
git branch -f master 5589877   # переместить ветку на указанный коммит
git branch --merged       # показать слитые ветки
git branch --no-merged    # показать не слитые ветки
git branch --contains v1.2   # ветки, среди предков которых есть коммит
git merge-base master feature  # общий предок двух веток
```

### `git checkout` / `git switch` — переключение

```bash
git switch -c feature/auth     # создать ветку и переключиться (аналог: git checkout -b)
git switch main                # переключиться на существующую ветку
git checkout -b new-branch     # создать и перейти (устаревший синтаксис)
git checkout -b new 5589877    # создать ветку от указанного коммита и перейти
git checkout -f branch         # принудительно переключиться, игнорируя изменения
git checkout -m branch         # попытаться сохранить изменения при переключении
git checkout --orphan newbranch  # создать «пустую» ветку без истории
git checkout -t origin/branch  # создать локальную ветку из удалённой (tracking)
```

**Detached HEAD** — состояние, когда HEAD указывает на коммит, а не на ветку. Коммиты здесь будут потеряны при переключении; решение: `git switch -c branch-name`.

### `git merge` — слияние

```bash
git merge feature             # влить ветку feature в текущую
git merge feature -m "msg"    # с сообщением
git merge feature --log       # добавить сообщения вливаемых коммитов
git merge feature --no-ff     # всегда создавать коммит слияния
git merge-base master feature # показать общий предок
```

- **Fast-forward merge** — целевая ветка является прямым предком исходной; Git просто двигает указатель.
- **3-way merge** — обе ветки содержат новые коммиты; Git создаёт merge-коммит.

```text
  ОБЩИЙ ПРЕДОК  →  РАСХОЖДЕНИЕ  →  MERGE (создаёт merge-коммит)
  c1 ─ c2 ──────────────────── c3 ── m ── (main)
        \                     /
         └──── c4 ── c5 ─────┘     ← сюда вливаем feature
                              (m = коммит слияния, 2 родителя)

  FAST-FORWARD (rebase/нет ответвлений) — просто двигает указатель:
  c1 ─ c2 ─ c3          git merge feature  (main прямо «двигается»)
              \                  
               └──── feature  →  вливается как c2 → c3 → c4
```

Почему rebase создаёт «чистую» линейную историю:

```text
  MERGE:                        REBASE:
  c1 ─ c2 ─ c3 ── m             c1 ─ c2 ─ c3 ─ c4' ─ c5'
        \     /                       (коммиты feature переписаны
         c4 ─ c5                       поверх main — один ровный ряд)
```

**Конфликты.** Git помечает конфликтные участки маркерами `<<<<<<<`, `=======`, `>>>>>>>`. Нужно оставить нужный код, удалить маркеры, проиндексировать и закоммитить.

```bash
git checkout --ours index.html      # при конфликте: оставить версию, КУДА вливаем (master)
git checkout --theirs index.html     # оставить версию, ИЗ КОТОРОЙ вливаем (feature)
git checkout --merge index.html      # показать сравнение для ручного редактирования
git reset --hard                     # прекратить прерванное слияние
git reset --merge                    # прекратить слияние, сохранив незакоммиченные изменения
```

### `git rebase` — линейная история

```bash
git rebase main            # наложить коммиты активной ветки на main
git rebase master topic    # наложить topic на master
git rebase -i HEAD~3       # интерактивно: редактировать последние 3 коммита
git rebase --onto master feature  # перенести коммиты на master
git rebase --continue      # продолжить после разрешения конфликта
git rebase --skip          # пропустить конфликтный коммит
git rebase --abort         # отменить rebase и вернуть всё как было
```

**Интерактивный rebase** (`-i`) позволяет: `pick` (оставить), `squash` (склеить коммиты), `reword` (изменить сообщение), `drop` (удалить), изменить порядок.

> **Золотое правило:** никогда не ребейсите ветки, которые уже запушены и используются другими — rebase переписывает хеши коммитов.

**Отменить rebase:**

```bash
git reflog feature -2          # найти последний коммит ДО rebase
git reset --hard feature@{1}   # вернуть указатель ветки
```

### `git cherry-pick` — копирование коммитов

```bash
git cherry-pick 5589877           # скопировать коммит на активную ветку
git cherry-pick -n 5589877        # без создания коммита
git cherry-pick master..feature   # все коммиты ветки с момента расхождения
git cherry-pick --abort           # прервать конфликтный перенос
git cherry-pick --continue        # продолжить после решения конфликта
```

### `git commit --amend` — исправить последний коммит (до push)

```bash
git add .
git commit --amend -m "Новое сообщение"   # заменить сообщение/содержимое последнего коммита
git commit --amend --author="New <email>"  # изменить автора
```

* * *

## Удалённые репозитории: remote / push / pull / fetch

```text
  ЛОКАЛЬНЫЙ РЕПОЗИТОРИЙ               УДАЛЁННЫЙ (GitHub/GitLab)
  ┌──────────────────────┐   push   ┌──────────────────────────┐
  │  main (local)        │─────────►│  main (origin)           │
  │  новые коммиты       │          │  коммиты появляются      │
  └──────────────────────┘          └──────────────────────────┘
              ▲  pull = fetch + merge
              │       │
              │  fetch◄┘  (забирает, но НЕ сливает)
              │
  полезно для понимания:
  - push  — отправить СВОИ коммиты на remote
  - fetch — скачать чужие коммиты, не трогая рабочую директорию
  - pull  — fetch + сразу merge (забрать и влить)
```

### `git remote` — управление удалёнными репозиториями

```bash
git remote -v                        # список подключённых удалённых репозиториев
git remote add origin URL            # добавить удалённый репозиторий (имя origin)
git remote remove origin             # удалить привязку
git remote rm origin                 # то же
git remote show origin               # данные об удалённом репозитории
```

Есть два способа привязки: по HTTPS и по SSH. GitHub отключил аутентификацию паролем по HTTPS, поэтому **рекомендуемый способ — SSH**, адрес начинается с `git@github.com:` (см. раздел «GitHub: доступ по HTTPS отключён → настраиваем SSH»).

### `git push` — отправить изменения

```bash
git push                # в удалённую ветку по умолчанию (если настроен tracking)
git push origin main    # в конкретную ветку
git push -u origin main # установить tracking для локальной ветки
git push origin master --tags   # вместе с тегами
git push origin --tags          # отправить все теги
git push --force origin main    # ПЕРЕЗАПИСАТЬ историю (осторожно!)
git push --force-with-lease     # безопасный force: отклонит, если remote изменился
git push origin :experimental   # удалить ветку на удалённом репозитории
git push origin master:experimental  # локальный master → удалённый experimental
git push origin --delete old-name    # удалить удалённую ветку
```

### `git pull` — забрать и слить

`git pull` = `git fetch` + `git merge`.

```bash
git pull                 # забрать и слить изменения текущей ветки
git pull origin main     # из указанной ветки
git pull --rebase        # вместо merge применить rebase (избегает merge-коммитов)
git pull username-project --tags  # вместе с тегами
```

Совет: включить rebase по умолчанию для pull:

```bash
git config --global pull.rebase true
```

### `git fetch` — забрать, но НЕ сливать

```bash
git fetch origin         # скачать ветки, не трогая рабочую директорию
git fetch origin master  # только указанную ветку
git fetch --dry-run      # показать, что будет скачано, без загрузки
git fetch upstream       # для синхронизации форка
```

После fetch можно посмотреть изменения: `git log origin/main`, а затем слить `git merge origin/main`.

* * *

## GitHub: доступ по HTTPS отключён → настраиваем SSH

GitHub больше не принимает **логин/пароль по HTTPS** для `git push` / `clone` / `fetch` (аутентификация паролем отключена давно, токены старого формата также перестали работать). Теперь у GitHub всего два рабочих способа аутентификации: **SSH-ключ** (рекомендуется) или **Personal Access Token** (PAT) для HTTPS. Ниже — раздел про SSH, как самый надёжный.

### Как выглядит ошибка при попытке доступа по HTTPS

Если репозиторий всё ещё привязан по `https://github.com/...` и GitHub отклоняет креды:

```text
remote: Support for password authentication was removed on August 13, 2021.
remote: Please see https://docs.github.com/.../about-remote-repositories for information on how to move forward.
fatal: Authentication failed for 'https://github.com/user/repo.git/'
```

Или (при неверном/отозванном токене):

```text
remote: Invalid username or password.
fatal: Authentication failed for 'https://github.com/user/repo.git/'
```

Как понять, что репо сидит на HTTPS:

```bash
git remote -v
# origin  https://github.com/user/repo.git (fetch)
# origin  https://github.com/user/repo.git (push)   ← так быть не должно
```

### Проверка текущего доступа (какой протокол использует ваш ПК)

```bash
ssh -T git@github.com
# Ожидаемый ответ:
# Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

### Полная настройка SSH-ключа на новом ПК

```bash
# 1. Создать ключ (лучше современный ed25519; rsa-4096 ниже — запасной вариант)
ssh-keygen -t ed25519 -C "you@example.com"
#   или:  ssh-keygen -t rsa -b 4096 -C "you@example.com"

# 2. Запустить агент SSH и добавить ключ
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# 3. Скопировать ПУБЛИЧНЫЙ ключ в буфер
cat ~/.ssh/id_ed25519.pub

# 4. Загрузить его на GitHub (вариант через сайт):
#    GitHub → Settings → SSH and GPG keys → New SSH key → вставить текст из п.3
#    Или через gh CLI:
#    gh auth login && gh ssh-key add ~/.ssh/id_ed25519.pub --title "my-pc"

# 5. Проверить подключение
ssh -T git@github.com
```

Добавленный текст публичного ключа начинается с `ssh-ed25519 AAAA...` (или `ssh-rsa AAAA...`).

### Перенастроить конкретный репозиторий с HTTPS на SSH

```bash
# Посмотреть текущий remote
git remote -v

# Переключить origin с HTTPS на SSH
git remote set-url origin git@github.com:user/repo.git

# Проверить
git remote -v
git fetch origin        # должно работать без ввода пароля
```

### Перенастроить весь ПК: сетевой протокол для gh CLI и новых клонов

```bash
# gh: использовать SSH в качестве протокола по умолчанию
gh auth login --hostname github.com --git-protocol ssh
# или в настройках уже вошедшего gh:
gh config set git_protocol ssh --host github.com

# Новые клоны по HTTPS-github адресу автоматически превращать в SSH:
git config --global url."git@github.com:".insteadOf "https://github.com/"
# после этого даже `git clone https://github.com/user/repo` пойдёт по SSH
# (убрать правило при необходимости: git config --global --unset-all url."git@github.com:".insteadOf)
```

### Для HTTPS-тока (если SSH по каким-то причинам невозможен)

```bash
# PAT создаётся на GitHub: Settings → Developer settings → Fine-grained tokens / Tokens (classic)
git config --global credential.helper store   # сохранит токен в открытом виде — только на своём ПК
# или:  git config --global credential.helper 'cache --timeout=86400'
```

* * *

## SSH-ключи для удалённого сервера (не GitHub)

Если нужно подключиться по SSH к своему VPS/серверу (а не к GitHub): после генерации ключа его **публичную** часть надо один раз положить в `~/.ssh/authorized_keys` на сервере. Дальше вход будет по ключу, без пароля.

### Быстрый способ: ssh-copy-id (рекомендуется)

Утилита сама копирует ключ, создаёт нужный файл и поправит права:

```bash
# один раз по паролю (запросит пароль удалённого пользователя):
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@server_ip

# если нужен конкретный ключ / другой порт:
ssh-copy-id -i ~/.ssh/id_myserver.pub -p 2222 user@server_ip

# после этого вход без пароля:
ssh user@server_ip
```

### Ручной способ (если ssh-copy-id нет)

```bash
cat ~/.ssh/id_ed25519.pub | ssh user@server_ip \
  "mkdir -p ~/.ssh && chmod 700 ~/.ssh && \
   cat >> ~/.ssh/authorized_keys && \
   chmod 600 ~/.ssh/authorized_keys"
```

Права **на сервере** важны: `~/.ssh` → `700`, `authorized_keys` → `600`, домашняя папка не должна быть доступна другим. Иначе sshd игнорирует ключи.

### Проверка подключения

```bash
ssh -T git@github.com       # проверка GitHub (ответ: Hi username! ...)
ssh user@server_ip          # обычный вход на сервер — ключ подхватится автоматически
ssh -i ~/.ssh/id_ed25519 user@server_ip   # явно указать ключ
ssh -vvv user@server_ip     # подробный вывод при проблемах
```

### Файл `~/.ssh/config` для удобства

```ini
Host myserver
    HostName server_ip
    User user
    IdentityFile ~/.ssh/id_myserver
```

Теперь вместо `ssh user@server_ip -i ~/.ssh/id_myserver` достаточно `ssh myserver`. Полезные параметры:

```ini
Host myserver
    HostName server_ip
    User user
    Port 2222                # нестандартный порт
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60   # не давать разрывать соединение
```

### Отключить парольный вход (после проверки, что ключи работают)

```bash
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd     # или: sudo systemctl restart ssh
```

> Перед отключением паролей убедитесь, что вход по ключу **точно работает** — иначе рискуете остаться без доступа к серверу.

* * *

## Алиасы SSH в `~/.ssh/config`

Файл `~/.ssh/config` задаёт **алиасы хостов**: вместо длинного `ssh user@server_ip -p 2222 -i ~/.ssh/id_myserver` достаточно короткого `ssh myserver`. Все ключи, порты и пользователи подставляются автоматически.

### Базовая запись для одного хоста

```ini
Host myserver
    HostName server_ip
    User user
    Port 22
    IdentityFile ~/.ssh/id_myserver
```

- `Host` — алиас, который вы набираете после `ssh` (без `@` и пути)
- `HostName` — реальный IP/домен
- `User` — логин по умолчанию (десятки `ssh myserver` вместо `ssh user@...`)
- `IdentityFile` — какой ключ использовать именно для этого хоста
- Опции записываются с **отступом** (таб или пробелы), `#` — комментарий

### Несколько алиасов на один сервер + туннели (пример с вашей машины)

```ini
# основной вход
Host myserver
    HostName server_ip
    User user
    IdentityFile ~/.ssh/id_myserver

# тот же сервер, но с проброшенным портом (туннель):
# после ssh myserver-grafana локальный http://localhost:3000 откроет порт 3000 на сервере
Host myserver-grafana
    HostName myserver        # ссылается на другой Host-блок
    LocalForward 3000 127.0.0.1:3000
```

Проброс портов из (`LocalForward` / `-L`) и в (`RemoteForward` / `-R`) сервер:

```bash
# -L: локальный порт → порт на сервере (без настроек в config):
ssh -L 3000:localhost:3000 myserver          # локальный :3000 → сервер :3000
ssh -R 9000:localhost:80 myserver            # порт 9000 сервера → локальный :80
```

### Маски, общие настройки и продвинутые опции

```ini
# правила применяются в порядке появления, первое совпадение выигрывает
Host *.example.com
    User dev
    ServerAliveInterval 60    # держать соединение живым
    ServerAliveCountMax 3

Host myserver
    HostName 10.0.0.5
    ProxyJump myserver           # входить через bastion-хост (см. Host myserver выше)
    LocalForward 8080 127.0.0.1:8080
    ConnectionAttempts 3
    ConnectTimeout 10
```

Часто используемые директивы:

| Директива | Что делает |
| --- | --- |
| `Host` / `HostName` | алиас / реальный адрес |
| `User` | логин по умолчанию |
| `Port` | порт, если нестандартный (по умолчанию 22) |
| `IdentityFile` | какой закрытый ключ брать |
| `LocalForward` / `RemoteForward` | тунель портов (`-L` / `-R`) |
| `ProxyJump` | заходить через промежуточный хост |
| `ServerAliveInterval` | keepalive-пинг, чтобы соединение не рвалось |
| `ConnectTimeout` | таймаут подключения |
| `StrictHostKeyChecking no` | не спрашивать про новый хост (осторожно, снижает защиту) |
| `Compression yes` | сжимать трафик (полезно на медленных каналах) |

Проверка и отладка:

```bash
ssh -G myserver         # показать, какие настройки применяются для алиаса
ssh -T -G myserver      # то же
ssh -vvv myserver       # подробный лог подключения
```

> Порядок строк важен: SSH использует **первое совпавшее** правило. Специфичные алиасы ставьте выше общих масок (`Host *`).

* * *

## Теги

```bash
git tag v1.0.0              # лёгковесный тег на HEAD
git tag stable-2 f292ef5    # тег на конкретный коммит
git tag -a v1.2.0 -m "Release"  # аннотированный тег с сообщением (для релизов)
git tag -l                  # список тегов
git tag -l "v1.*"           # фильтр по шаблону
git tag -n                  # теги с одной строкой сообщения
git tag -d v1.0.0           # удалить тег
git tag -f stable-1.1       # перезаписать существующий тег
git push origin --tags      # отправить теги на сервер
git describe --tags         # номер версии относительно последнего тега
```

**SemVer**: `MAJOR.MINOR.PATCH` — `v2.1.3` (мажорная, минорная, патч). Для релизов всегда используйте аннотированные теги.

* * *

## Файлы `.gitignore` и `.gitattributes`

### `.gitignore` — какие файлы игнорировать

Файлы и директории, не попадающие в репозиторий (зависимости `node_modules/`, сборка `dist/`, секреты `.env`). Пример содержимого:

```gitignore
# комментарий
node_modules/
build/
dist/
.env
*.log
!important.log
```

### Если забыли добавить файлы в `.gitignore` после коммита

```bash
echo "node_modules/" >> .gitignore
git rm -r --cached node_modules/   # убрать из отслеживания, не удаляя с диска
git commit -m "Update .gitignore"
```

### `.gitattributes` — нормализация переносов и diff

```ini
* text=auto

*.html diff=html
*.css  diff=css
*.scss diff=css
*.png  binary
```

Строка `* text=auto` автоматически конвертирует CRLF в LF при коммите — критично для команд с Windows- и Linux-разработчиками.

* * *

## GitHub CLI (gh)

Работа с GitHub прямо из терминала.

```bash
gh auth login               # вход в GitHub через CLI
gh auth logout              # выход
gh repo clone OWNER/REPO    # клонировать (автоматически настраивает аутентификацию)
gh repo create my-new-repo  # создать репозиторий (интерактивно или с параметрами)
gh repo list                # список репозиториев
gh repo edit OWNER/REPO     # изменить настройки репозитория
gh repo delete OWNER/REPO   # удалить репозиторий
gh issue list               # список Issues
gh issue create --title "Заголовок" --body "Описание"
gh pr list                  # список Pull Request
gh pr create --base main --head mybranch --title "Фича"
```

* * *

## lazygit

Терминальный UI (GUI в консоли) для Git на Go (автор — Jesse Duffield). Позволяет работать с репозиториями без запоминания команд: стейджинг, коммиты, ветки, merge/rebase/squash — всё через горячие клавиши. Работает на Linux, macOS, Windows (и даже FreeBSD).

### Зачем нужен lazygit

Lazygit — это удобный терминальный UI для Git, который позволяет быстро и легко управлять репозиториями без сложных команд в консоли.

**Основные преимущества:**

- **Атомарные коммиты без усилий:** Вместо `git add .` можно построчно или поблочно добавлять изменения в стейджинг нажатием пробела — это позволяет создавать идеально чистые, логически разделённые коммиты.
- **Безболезненный интерактивный rebase:** Вместо редактирования текстового файла при `git rebase -i HEAD~5` — наглядный список коммитов, где можно объединять, переименовывать и менять порядок.
- **Визуализация веток и истории:** Наглядный граф веток, видно где HEAD, какие коммиты не отправлены, cherry-pick — просто выбор коммита и нажатие кнопки.
- **Быстрое разрешение конфликтов:** При конфликте слияния lazygit предлагает удобный интерфейс для выбора нужного блока кода нажатием одной клавиши.

### Об инструменте

Автор проекта — [Jesse Duffield](https://jesseduffield.com/about/), разработчик из Мельбурна. Начиналось всё как хобби: по словам Jesse, он хотел чтобы и другие разработчики могли быть такими же ленивыми, как он сам. На текущий момент вокруг утилиты собралось довольно большое сообщество. В разработке поучаствовало уже 178 контрибьюторов. У проекта 32 тыс. звезд на GitHub.

Lazygit написан на Go, распространяется под лицензией MIT и работает под всеми доступными операционными системами.

![](https://habrastorage.org/getpro/habr/upload_files/970/e91/6bd/970e916bd82ee5b1d5cff8da211c4294.gif)

GUI сделан на основе библиотеки [gocui](https://github.com/jroimartin/gocui), с помощью которой можно реализовать полноценные окна и взаимодействие с ними в терминале.

#### Установка утилиты

Разработчики [подготовили](https://github.com/jesseduffield/lazygit#installation) сборки для всех существующих ОС, даже для FreeBSD (!).

*В примерах ниже тесты проводятся на macOS (Homebrew), но lazygit одинаково ставится на всех ОС.*

Установка (пример для macOS — Homebrew; для Linux — пакетный менеджер, см. раздел «Установка» выше):

```bash
brew install lazygit
```

После установки запустить программу можно командой `lazygit`. Если в каталоге, в котором вы находитесь, уже инициализирован Git-репозиторий, он сразу же будет подхвачен, и можно начинать работать. Если репозитория нет,  программа спросит, нужно ли его там создать, предоставив на выбор два варианта: создать или отказаться (во втором случае программа не запустится).

#### Обзор интерфейса

Для примера рассмотрим [репозиторий werf](https://github.com/werf/werf). Склонируем его, перейдем в каталог и запустим утилиту:

```bash
$ lazygit
```

![](https://habrastorage.org/r/w1560/getpro/habr/upload_files/f96/bbe/09f/f96bbe09f394908942463f6f99ca375a.png)

Главный интерфейс программы разделен на несколько окон:

- *Files* — здесь отображаются измененные файлы, если они есть.
    
- *Local branches* — локальные ветки в склонированном репозитории.
    
- *Commits* — все последние коммиты.
    
- *Diff* — дифф изменений.
    
- *Command log* — лог работы.
    

Рассмотрим подробнее основные возможности программы.

#### Работа с ветками

#### Переключение на удаленную ветку

В некоторых окнах можно переключиться на другой режим. Например, в окне с ветками можно просмотреть не только локальные, но и все ветки в удаленном репозитории, переключившись на режим *Remotes*. Для этого выбираем нужный репозиторий и нажимаем клавишу Enter.

*Если ваш терминал поддерживает работу с мышью — как, например, iTerm2 в macOS, — можно просто нажать на нужную строку.*

![](https://habrastorage.org/getpro/habr/upload_files/a61/97e/ef6/a6197eef63b3dd03999c220656f51169.png)

После выбора репозитория появится список всех доступных удаленных веток. В окне *Diff* при этом отобразится структура коммитов в соответствии с этими ветками:

![](https://habrastorage.org/getpro/habr/upload_files/bbc/e5d/2e9/bbce5d2e9134a4fc6905ca09af216a04.png)

Чтобы начать работать с веткой, на нее нужно переключиться — например, с помощью Space. При этом название локальной ветки, если необходимо, можно изменить:

![](https://habrastorage.org/getpro/habr/upload_files/8cc/d5e/d4c/8ccd5ed4cdb60ad98175500fc911dc6e.png)

После этого она станет доступна в разделе *Local Branches*.

#### Обновление веток

Если состояние текущей ветки актуально, она помечается зеленой галочкой.

Если локальная ветка «отстала» от мейнстрима, вместо галочки будет отображена стрелка, соответствующая состоянию отличий:

- стрелка вниз — требуется скачать новые коммиты из удаленного репозитория;
    
- стрелка вверх — нужно отправить изменения.
    

![](https://habrastorage.org/getpro/habr/upload_files/8fb/18b/660/8fb18b660801e3814577d8163ef8d821.png)

На примере выше отображены две ветки: `fix-in-usage-style` в актуальном состоянии, и `main`, отставшая от мейнстрима на 14 коммитов.

Любую ветку можно обновить, выполнив `fetch` или `pull`. Программа позволяет сделать это с помощью горячих клавиш: переходим на нужную ветку и нажимаем клавишу **f** или **p** в зависимости от команды, которую нужно выполнить.

*Горячая клавиша может не сработать, если включена русская раскладка. Регистр также имеет значение — в этом конкретном случае нужно нажимать на маленькую f или p.*

![](https://habrastorage.org/getpro/habr/upload_files/cfe/4a0/71f/cfe4a071f14494065059a3e6f73fec5b.png)

#### Создание новой ветки

Создать новую ветку можно с помощью клавиши **n**, выбрав ту ветку, от которой нужно ветвиться. Программа предложит ввести название новой ветки. После ввода будет создана новая, готовая к работе локальная ветка; она сразу появится в окне *Local Branches*.

*Обратите внимание, что программа автоматически ничего никуда не отправляет, и созданная ветка будет только на вашей машине. Для отправки ее в удаленный репозиторий нужно, как обычно, сделать* `commit` *и* `push`*.*

![](https://habrastorage.org/getpro/habr/upload_files/569/447/4b8/5694474b89a484593a3c2ab931c29068.png)

#### Merge веток

Выполнить merge веток можно горячей клавишей **M**. Для этого сначала нужно переключиться на целевую ветку, затем выбрать ту, из которой будут вноситься изменения, и нажать **M**.

![](https://habrastorage.org/getpro/habr/upload_files/ec0/62d/de6/ec062dde611f7c1ef9fe43b236042724.png)

#### Внесение изменений, commit и push

#### Commit изменений

После того, как новая ветка создана, можно вносить изменения в код. По завершении в левом верхнем окне программы (*Files*) появится список изменившихся файлов, которые можно закоммитить в репозиторий:

![](https://habrastorage.org/r/w1560/getpro/habr/upload_files/4f1/212/ead/4f1212ead8e9551db3d361c9c5f7230b.png)

В правом окне *Diff* будут отображаться все изменения, внесенные в конкретный файл.

Чтобы зафиксировать изменения, нажимаем клавишу **a** (`git add`). Все измененные файлы позеленеют, то есть будут готовы к коммиту.

![](https://habrastorage.org/r/w1560/getpro/habr/upload_files/cfc/1c6/3f8/cfc1c63f8aaa5671b243f9194178d6bd.png)

Чтобы закоммитить изменения, нажимаем клавишу **c** и в открывшемся окне вводим описание коммита.

![](https://habrastorage.org/getpro/habr/upload_files/a2b/15a/ae5/a2b15aae522fdc9566304d7ab5950305.png)

Новый коммит появится в нижнем левом окне *Commits*.

#### Изменение описания коммита

Чтобы исправить описание коммита, переходим в окно *Commits* и выбираем нужный коммит. Нажимаем клавишу **r** (rename) — после этого возвращаемся в то же самое окно, в котором можно изменить текст.

#### Push в удаленный репозиторий

Для отправки зафиксированных изменений в удаленный репозиторий используется сочетание клавиш **Shift + P**.

Если вы делаете это впервые, программа спросит, с каким удаленным репозиторием предстоит работать и в какую ветку отправлять изменения.

![](https://habrastorage.org/getpro/habr/upload_files/44d/674/ba8/44d674ba8f5fad4b794150f47e62d782.png)

Здесь лучше оставить всё как есть: локальный репозиторий и удаленный должны быть одинаковыми во избежание неприятных казусов в будущем.

*Если именовать ветки по-разному, в будущем можно запутаться в том, что и куда должно отправляться. Это может привести к неприятным ситуациям, когда изменения будут отправлены не в ту ветку, а также к потраченному впустую времени на поиск правильного пути.*

Перейдем к более сложным задачам.

#### Squah, rebase и force-push коммитов

#### Squash и force-push

Часто требуется делать промежуточные коммиты, чтобы не потерять наработки или зафиксировать важную часть прогресса по задаче. При этом коммиты нужно отправить в свою ветку с изменениями в удаленном репозитории.

Например, мы создали промежуточный комментарий, назвав его просто `+++`.

![](https://habrastorage.org/getpro/habr/upload_files/1c3/cac/8ae/1c3cac8ae31a40a01f0266fbaf46bb06.png)

Отправим изменения в репозиторий (**Shift + P**).

Теперь продолжим работу до момента, когда понадобится закончить текущую правку и объединить предыдущий коммит с последним. Как обычно, закоммитим изменения:

![](https://habrastorage.org/getpro/habr/upload_files/d70/7dd/e72/d707dde72d9e3e8d16f5cb5269190021.png)

Далее необходимо «слить» последний коммит с предыдущим. Сделать это можно горячей клавишей **s**. Программа, запросив подтверждение, сделает squash коммита со следующим, расположенным ниже по списку.

Теперь два последних коммита объединены в один. Осталось их переименовать (по умолчанию имя общего коммита содержит описания обоих коммитов). Нажимаем **r** и удаляем лишнее (`+++`):

![](https://habrastorage.org/getpro/habr/upload_files/5bf/34a/494/5bf34a494382df5cde6f14d2cd04830c.png)

Отправим изменения в удаленный репозиторий. Так как локальная ветка отличается от удаленной, необходимо не просто выполнить push изменений, а сделать это в режиме **–force**, чтобы изменения перезаписались.

*Обратите внимание, что push с force нужно выполнять только тогда, когда есть четкое понимание, для чего это делается. Операция перезаписывает содержимое всей удаленной ветки, что может привести к потере данных. Например, два человека одновременно работают с одной веткой над какой-то небольшой правкой, и оба по очереди перезаписали удаленную ветку своими изменениями. Если не уследить за своевременной синхронизацией, вероятность потери данных сильно возрастает. Также нужно помнить, что ни в коем случае не следует выполнять такой push к главной ветке репозитория (master или main).*

Для отправки изменений снова нажимаем **Shift + P**. Программа определит, что удаленная ветка отличается от локальной и сама предложит сделать push с force.

![](https://habrastorage.org/getpro/habr/upload_files/980/fd1/594/980fd15942ae6cc369c4a64c126cbf28.png)

#### Rebase ветки

Рассмотрим еще один частый случай. Например, во время работы текущая ветка отстала от мейнстрима, и необходимо актуализировать состояние с помощью rebase.

Для этого нужно:

- переключиться на ветку, rebase которой будем выполнять;
    
- выбрать ветку, на которую будет производиться rebase.
    

На скриншоте показан пример rebase ветки `fix-in-usage-style` на ветку `main`:

![](https://habrastorage.org/getpro/habr/upload_files/359/555/432/3595554329ff349419bcf8e7a7553a7d.png)

В случае успешного завершения процесса в дереве коммитов появятся все «новые» коммиты, соответствующие актуальному состоянию ветки `main`. Последние коммиты, внесенные в ветку `fix-in-usage-style`, будут всё так же сверху.

![](https://habrastorage.org/getpro/habr/upload_files/d5a/4d8/238/d5a4d8238e67e20697191e68bfc273e3.png)

Чтобы зафиксировать изменения в удаленном репозитории, необходимо выполнить push (**Shift + P**).

#### Разрешение конфликтов слияния

При возникновении конфликта слияния lazygit предлагает удобный интерфейс для его разрешения:

1. При конфликте в окне *Files* появятся файлы с конфликтами (помечены красным).
2. Выберите конфликтный файл и нажмите **Enter** — откроется diff с конфликтными блоками.
3. Используйте клавишу **Space**, чтобы выбрать нужный вариант (наша версия / их версия) для каждого блока.
4. После разрешения всех конфликтов нажмите **a** для добавления файла в staging и **c** для коммита.
5. Lazygit также позволяет открыть файл во внешнем редакторе для ручного редактирования.

> Совет: при работе в команде лучше всегда обсуждать конфликтные блоки с коллегами перед принятием решения.

#### Вызов справки

В любом из окон можно вызвать справку с перечнем всех доступных горячих клавиш, нажав **x**.

![](https://habrastorage.org/getpro/habr/upload_files/111/4bf/b02/1114bfb023930af6c61de9baef7002e4.png)

#### Конфигурация

Программу можно гибко настраивать под себя, начиная с цветовой гаммы и заканчивая добавлением новых команд или горячих клавиш. Все настройки лежат в файле `config.yml`, который размещается в разных каталогах в зависимости ОС:

- Linux: `~/.config/lazygit/config.yml`
    
- MacOS: `~/Library/Application Support/lazygit/config.yml`
    
- Windows: `%APPDATA%\lazygit\config.yml`
    

Более подробно о всех доступных настройках написано [в официальной документации](https://github.com/jesseduffield/lazygit/tree/master/docs).

#### Завершение работы

Для выхода из программы необходимо нажать горячую клавишу **q**.

Lazygit — это удобный терминальный UI для Git, который позволяет быстро и легко управлять репозиториями без сложных команд в консоли.

### Основные горячие клавиши

| Действие | Клавиша |
| --- | --- |
| Добавить/убрать файл из стейджинга | `SPACE` |
| Добавить/убрать **все** файлы | `a` |
| Сбросить изменения файла (discard) | `d` |
| Коммит (окно Files) | `c` |
| Открыть детали/diff | `enter` |
| Сжать коммиты (squash c нижеследующим) | `s` |
| Переименовать описание коммита | `r` |
| Amend (дополнить последний коммит) | `A` |
| Переключиться на ветку | `c` |
| Rebase текущей ветки на выбранную | `r` |
| Создать новую ветку | `n` |
| Merge выбранной ветки в текущую | `M` |
| Fetch для выбранной ветки | `f` |
| Pull для выбранной ветки | `p` |
| Push (или push с force, если предложит) | `Shift+P` |
| Вызвать справку по всем клавишам | `x` или `?` |
| Выйти | `q` |

### Разбор интерфейса

- **Левая панель** — главное навигационное меню, где в зависимости от режима (файлы, коммиты, ветки) вы видите список элементов.
- **Правая панель** — показывает подробности: диффы, сообщения коммитов и др.
- **Строка состояния** — внизу отображает текущие подсказки по доступным действиям в выбранном контексте.

### Клавиши и команды — примеры

| Действие | Клавиша/Команда | Краткое объяснение |
| --- | --- | --- |
| Запуск Lazygit | `lazygit` | Открыть терминал с UI |
| Добавить выбранный файл в стейдж | `SPACE` | Выделить файл и нажать пробел |
| Сделать коммит | `c` (в окне файлов) | Открыть окно ввода сообщения коммита |
| Отменить изменения в файле | `d` | Discard изменений в выбранном файле |
| Открыть детали файла | `enter` | Показать diff для выбранного файла |
| Переключиться на вкладку веток | `tab` или `l`/`h` | Переключение между секциями UI |
| Переключиться на ветку | `c` (в окне веток) | Checkout выбранной ветки |
| Отправить изменения (push) | `Shift + P` | Отправить локальные коммиты в удалённый репозиторий |
| Вызвать справку (hotkeys) | `?` или `x` | Показать полный список горячих клавиш |
| Выйти из Lazygit | `q` | Закрыть приложение |

### Лучшие практики

- Перед коммитом всегда проверяйте diff выбранных файлов (`enter`) — это максимально просто, показывая все изменения.
- Используйте быстрые клавиши (`SPACE`, `c`, `d`) для ускорения типичных операций.
- Для сложных операций (rebase, работа с ветками) переключайтесь в соответствующую панель и используйте `r`.
- Маленькие промежуточные коммиты удобно сжимать `s` и править `r` — без длинных консольных команд.
- Настройте собственные горячие клавиши и цвета через конфигурационный файл `~/.config/lazygit/config.yml` для удобства.
- Воспользуйтесь функцией stash (`s`), если нужно временно убрать изменения и переключиться на другую задачу.
- В интерактивном режиме можно быстро сжимать коммиты (squash), делать amend и исправлять историю без длинных команд.

### Пример рабочего процесса (коммит и пуш)

1. Открываете lazygit в папке проекта.
2. В окне Files выбираете пробелом файлы для коммита.
3. Жмёте `c` — вводите сообщение коммита.
4. Переходите во вкладку Branches, выбираете ветку для пуша.
5. Нажимаете `Shift+P` для отправки коммитов на сервер.

* * *

## Визуальные Git-клиенты (open source)

Команды — это мощно, но иногда удобнее «видеть» проект. Всё ниже — полностью открытый код и бесплатно.

### Встроенные: gitk и git-gui

Идут вместе с Git и ничего устанавливать не надо:

```bash
gitk          # графический граф истории коммитов (branches/merge)
git gui       # простой GUI для add / commit
```

### tig — TUI-клиент в терминале

Интерактивный просмотр истории прямо в консоли (работает даже по SSH).

```bash
sudo apt install tig        # Debian/Ubuntu/ALT
sudo pacman -S tig          # Arch
tig                          # запуск в репозитории
```

Быстрое освоение: `Enter` — детали коммита, `t` — дерево файлов, `1/2/3` — окна, `q` — выход.

### Git Cola — лёгкий GUI

Простой и понятный графический клиент для ежедневных add/commit/branch/push.

```bash
sudo apt install git-cola    # Debian/Ubuntu/ALT
sudo pacman -S git-cola      # Arch
```

### GitAhead — современный GUI (Qt)

Красивый кросс-платформенный клиент с наглядной историей, ветками, стейджингом и встроенным diff-редактором. Установка — со страницы релизов проекта (AppImage) или через альтернативу Gitg:

```bash
flatpak install flathub io.gitgir.gitg     # Gitg — похожий по возможностям клиент
```

### lazygit — уже разобран выше

Терминальный (TUI) клиент, который многие предпочитают даже GUI — см. соответствующий раздел выше.

> Принцип выбора: для «дёргать из консоли» — `tig`; для новичка, который хочет мышь — `Git Cola`; для мощного визуального анализа истории — `gitk` / `GitAhead` / `Gitg`.

* * *

## Продвинутые инструменты

### `git bisect` — поиск сломавшего коммита

```bash
git bisect start
git bisect bad            # текущий коммит сломан
git bisect good v1.0.0    # эта версия работала
# Git переключается на средний коммит — проверяете:
git bisect good           # или git bisect bad
# ...повторяется, пока не найдётся виновник
git bisect reset          # выйти из режима
```

### `git worktree` — несколько рабочих директорий

```bash
git worktree add ../hotfix hotfix/critical-bug   # для существующей ветки
git worktree add -b new ../path main             # с новой веткой
git worktree list          # список
git worktree move old new  # переместить
git worktree remove ../path # удалить
```

### `git submodule` — вложенные репозитории

```bash
git submodule add https://github.com/jquery/jquery.git  # добавить подмодуль
git clone --recursive URL           # клонировать с подмодулями
git submodule update --init --recursive   # инициализировать и обновить после клона
git submodule update --recursive    # привести к зафиксированному состоянию
git submodule update --remote submodule_dir  # обновить до последнего коммита
git submodule foreach git pull      # обновить все подмодули
git submodule deinit the_submodule  # удалить описание подмодуля
git rm the_submodule                # удалить каталог подмодуля
git mv /path/to/module new/path     # переместить подмодуль
```

### `git lfs` — большие файлы

```bash
git lfs install          # инициализировать поддержку
git lfs track "*.psd"    # отслеживать большие файлы
```

Большие файлы (изображения, видео, модели) не хранятся в истории Git — их заменяют указателями, а сами файлы лежат на отдельном сервере.

### `git archive` — архив проекта

```bash
git archive -o ./project.zip HEAD   # создать zip-архив состояния HEAD
```

### Переписывание истории / очистка

```bash
git filter-branch --env-filter '...' -- --branches --tags   # массовое переписывание (старое)
# Современная замена: фильтр git filter-repo (устанавливается: pip install git-filter-repo)
```

> Важно: после переписывания истории нужен `git push --force` (лучше `--force-with-lease`).

### `git format-patch` / `git apply` — передача изменений патчами

Когда нет доступа к общему remote (или нужно передать изменения в обход сети), экспортируйте коммиты в файлы-патчи:

```bash
git format-patch -1 HEAD              # патч последнего коммита в .patch-файл
git format-patch -3 HEAD ~n           # несколько последних коммитов
git apply 0001-<описание-коммита>.patch  # применить патч (без коммита)
git am 0001-*.patch                   # применить патч и создать коммит(ы)
```

* * *

### Git Hooks — автоматизация проверок

Git hooks — скрипты, которые Git автоматически запускает при определённых событиях (перед коммитом, после push, при получении изменений). Позволяют автоматизировать проверки качества без настройки CI/CD.

Основные клиентские хуки:

- `pre-commit` — запускается перед коммитом: линтинг, форматирование, проверка секретов.
- `commit-msg` — проверяет сообщение коммита (например, соответствие Conventional Commits).
- `pre-push` — запускается перед push: можно прогнать тесты.
- `post-checkout` — после `git checkout`/`git switch`: автоустановка зависимостей при смене ветки.

Серверные хуки (`pre-receive`, `post-receive`) выполняются на стороне сервера и контролируют, какие push-запросы принимать (запрет force-push в main, обязательный code review и т. д.).

```bash
#!/bin/sh
# .git/hooks/pre-commit — запрет коммита с TODO
if git diff --cached | grep -q 'TODO'; then
  echo "ERROR: Commit contains TODO markers"
  exit 1
fi
```

> Хуки хранятся в `.git/hooks/` и не попадают в репозиторий. Инструменты **Husky** (JS), **pre-commit** (Python) и **Lefthook** (Go) решают эту проблему: хуки описываются в конфигурации, которая коммитится, и ставятся при установке зависимостей.

* * *

## Командная работа: workflow и best practices

Без договорённостей Git в команде быстро превращается в хаос. Workflow — набор правил о том, как работать с ветками, коммитами и релизами.

### Git Flow, GitHub Flow и Trunk-Based

- **Git Flow** — формальная модель с ветками `develop`, `release`, `hotfix`. Подходит для проектов с чётким циклом релизов.
- **GitHub Flow** — упрощённый: `main` + feature-ветки + pull requests. Подходит для web-проектов с непрерывным деплоем.
- **Trunk-Based Development** — все работают в `main`, feature-ветки живут 1–2 дня. Требует зрелого CI/CD и feature flags.

### Conventional Commits и именование веток

Формат сообщений коммитов, позволяющий автоматически генерировать changelogs: `type(scope): description`. Основные типы: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`.

Именование веток: `type/description`, например `feature/user-auth`, `fix/login-crash`; при использовании трекера — `feat/PROJ-123_user-auth`.

### Code review и защита веток

Хороший PR: небольшой и фокусированный, с описанием «зачем», скриншотами и ссылкой на задачу в трекере. **Branch protection rules** позволяют запретить push напрямую в `main`, потребовать минимум один approve и прохождение CI перед слиянием.

Файл `CONTRIBUTING.md` в корне репозитория описывает правила контрибуции; GitHub автоматически показывает ссылку на него при создании issue и PR.

* * *

## Платформы для хостинга Git-репозиториев

Git универсален — меняется только хостинг.

**Облачные платформы:**

- **GitHub** — крупнейшая платформа (Pull Requests, Issues, Actions, Pages, Copilot).
- **GitLab** — DevOps-платформа «всё в одном»: CI/CD, реестр контейнеров, Wiki; есть self-hosted версия.
- **Bitbucket** — от Atlassian, интегрирован с Jira и Confluence; бесплатен для команд до 5 человек.
- **GitVerse** (gitverse.ru) — платформа от Сбера: хостинг, CI/CD, code review, локальная юрисдикция данных.
- **GitFlic** (gitflic.ru) — Git-хостинг с приватными репозиториями и встроенным CI/CD, есть бесплатный тариф.

**Self-hosted:**

- **GitLab CE** — бесплатная версия для своего сервера.
- **Gitea** — лёгкий open-source Git-сервер на Go, минимум ресурсов, разворачивается за минуты.
- **Codeberg** — некоммерческий бесплатный хостинг на базе Gitea для open-source проектов.

### GitHub Actions и CI/CD

Workflow описываются в YAML-файлах в `.github/workflows/` и запускаются по событиям:

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm test
```

Ключевые концепции:

- **Triggers** — события: `push`, `pull_request`, `schedule` (cron), `workflow_dispatch` (ручной запуск).
- **Runners** — среда выполнения: GitHub-hosted (`ubuntu-latest` и др.) или self-hosted.
- **Secrets** — зашифрованные переменные через `${{ secrets.API_KEY }}`.
- **Артефакты и кеш** — сохранение результатов сборки и кеширование зависимостей между запусками.

Также из экосистемы GitHub: **Pages** (хостинг статических сайтов), **Dependabot** (автообновление зависимостей), **code scanning** и **secret scanning**, **Packages** (реестр пакетов), **Projects** (Kanban-доска).

* * *

## Git на собеседованиях (частые вопросы)

- **Rebase vs merge?** Merge — для публичных веток (сохраняет историю), rebase — для локальных feature-веток (чистая история). Золотое правило: `feature → rebase, main → merge`.
- **Reset vs revert?** Revert безопасен (новый коммит), reset переписывает историю. `reset --soft/--mixed/--hard`.
- **Что такое fast-forward merge?** Линейное перемещение указателя без merge-коммита, когда ветка «впереди» без расхождений.
- **Что такое detached HEAD?** HEAD указывает на коммит, а не на ветку; коммиты будут потеряны без создания ветки.
- **Как работает cherry-pick?** Копирует один коммит в текущую ветку с новым хешем.
- **Что такое stash и когда использовать?** Временное хранилище незакоммиченных изменений; сценарий — переключение контекста.
- **Чем Git отличается от GitHub?** Git — локальная система контроля версий, GitHub — веб-хостинг репозиториев с дополнительными инструментами.
- **Как откатить последний коммит?** Уже запушен — `git revert HEAD` (безопасно). Локальный — `git reset --soft HEAD~1` (сохраняет изменения в staging).

На senior-позициях спрашивают глубже: устройство Git изнутри (DAG, объекты blob/tree/commit/tag), стратегии ветвления для микросервисов, защита веток, организация монорепозитория.

* * *

## GitHub Pages

Бесплатный хостинг статических сайтов прямо из репозитория.

```bash
git clone https://github.com/username/username.github.io
```

Алгоритм размещения:

1.  Регистрация на GitHub и создание репозитория `username.github.io` (где `username` — ваш ник).
2.  Создать файл `index.html` (и `style.css`) и закоммитить:
    
    ```
    git add .
    git commit -m "Initial page"
    git push origin main
    ```
    
3.  В настройках репозитория: **Settings → Options → GitHub Pages** подтвердить публикацию.
4.  Страница доступна на `https://username.github.io`.

Для привязки своего домена — создайте файл `CNAME` и настройте DNS.

* * *

## Практические рецепты

### Начало работы: новый репозиторий + первый коммит + push

```bash
git init
touch readme.md
git add readme.md
git commit -m "Старт"
git remote add origin https://github.com/user/repo.git
git push -u origin main
```

### Быстрый универсальный цикл работы с репозиторием

```bash
git clone <url>
git pull                     # обновить локальную копию
git status                   # посмотреть изменения
git add .
git commit -s -m "Описание изменений"
git push
```

### Очистка истории коммитов (запушить «с чистого листа»)

```bash
rm -rf .git                  # удалить старую историю
git init                     # инициализировать новый репозиторий
git add .
git commit -m "Initial commit"
git remote add origin git@github.com:user/yourrepo.git
git push --force origin main # ВНИМАНИЕ: перезаписывает удалённую историю!
```

Если нужно удалить только часть коммитов — используйте `git rebase -i` или BFG Repo-Cleaner.

### Синхронизация форка с мастер-репозиторием

```bash
git remote add upstream https://github.com/address.git
git fetch upstream
git checkout master
git merge upstream/master
```

### Изменение автора во всех коммитах (filter-branch)

```bash
git filter-branch --env-filter '
OLD_EMAIL="old@example.com"
CORRECT_NAME="Correct Name"
CORRECT_EMAIL="correct@example.com"
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]; then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]; then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags
```

### Создание пустого репозитория на сервере

```bash
mkdir repo.git && cd repo.git
git init --bare
chown git. -R ./
```

### Импорт SVN-репозитория на Git-сервер

```bash
git svn clone -s http://svn.example.com/repo repo
cd repo
git push --mirror <git-server>:repo.git   # переносим в пустой bare-репозиторий
```

### Вернуться к состоянию до слияния (откат merge)

```bash
git checkout master
git merge fix
git branch -f master ORIG_HEAD   # вернуть master на коммит до слияния
```

### Запушить без запроса логина/пароля (HTTPS)

```bash
git config --global credential.helper cache
```

### Серверные команды обслуживания репозитория

```bash
git update-server-info   # создать info/refs и объектные пакеты для dumb-сервера
git count-objects        # сколько объектов и места занимает репозиторий
git gc                   # переупаковка/очистка (сборщик мусора)
```

* * *

## Полезные ресурсы

- **Pro Git** (бесплатная книга на русском): https://git-scm.com/book/ru/v2
- Документация GitHub: https://docs.github.com

* * *
