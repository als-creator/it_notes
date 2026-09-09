# Kubernetes — интерактивный учебник-практикум

**Kubernetes** (K8s) — система оркестрации контейнеров, которая автоматически управляет запуском, масштабированием и восстановлением контейнеризированных приложений. Если Docker создаёт один контейнер, то Kubernetes управляет сотнями и тысячами контейнеров на кластере серверов. Разработан Google, стал стандартом для продакшн-деплоя.

Учебник-практикум для новичков: теория → ASCII-схема → «Попробуй сам» → «Задание» → «Самопроверка». Актуально для **Kubernetes 1.29+** (проверено на k3s 1.36): все манифесты используют стабильные API `apps/v1`, `v1`, `networking.k8s.io/v1`, `autoscaling/v2`.

> Всё, что требует кластера, помечено «запусти, когда есть кластер». Синтаксис сверен с официальной документацией kubernetes.io/ru/docs и kubernetes.io/docs. Импортируется в Joplin и Obsidian как обычный Markdown.

## Содержание

- [1. Что решает Kubernetes](#1-что-решает-kubernetes)
- [2. Кластер: управляющий слой и рабочие узлы](#2-кластер-управляющий-слой-и-рабочие-узлы)
- [3. Концепции Kubernetes с примерами](#3-концепции-kubernetes-с-примерами)
- [4. Установка локального кластера](#4-установка-локального-кластера)
- [5. kubectl: основные команды](#5-kubectl-основные-команды)
- [6. Pod и его жизненный цикл](#6-pod-и-его-жизненный-цикл)
- [7. Deployment: реплики, rollout, стратегии](#7-deployment-реплики-rollout-стратегии)
- [8. Service: ClusterIP, NodePort, LoadBalancer](#8-service-clusterip-nodeport-loadbalancer)
- [9. Ingress и ingress-контроллер](#9-ingress-и-ingress-контроллер)
- [10. ConfigMap и Secret](#10-configmap-и-secret)
- [11. Хранение данных: Volume, PV, PVC](#11-хранение-данных-volume-pv-pvc)
- [12. Сеть: поды, сервисы, DNS](#12-сеть-поды-сервисы-dns)
- [13. Namespace для изоляции](#13-namespace-для-изоляции)
- [14. Ресурсы requests/limits и автоподмасштабирование](#14-ресурсы-requestslimits-и-автоподмасштабирование)
- [15. Проверки здоровья: probes](#15-проверки-здоровья-probes)
- [16. Деплой приложения: полный пример](#16-деплой-приложения-полный-пример)
- [17. Проекты-практикумы](#17-проекты-практикумы)
- [18. Литература и ссылки](#18-литература-и-ссылки)

---

## 1. Что решает Kubernetes

**Теория.** Docker умеет запускать контейнеры на одном хосте. Kubernetes (K8s — от восьми букв между «K» и «s») — это **оркестратор**: он управляет тысячами контейнеров на десятках серверов и делает три главные вещи:

- **Автоматическое размещение** — scheduler сам решает, на каком узле запустить под.
- **Самовосстановление** — упавший контейнер перезапускается, удалённый создаётся заново.
- **Масштабирование и обновления** — легко увеличить число копий приложения и раскатать новую версию без простоя.

Базовая единица — **Pod**: одна или несколько логически связанных контейнеров, которые делят сеть и тома. Поды живут на **узлах** (nodes) — машинах кластера. Вся эта конструкция называется **кластером**: управляющий слой (control plane) + рабочие узлы.

**Схема — от контейнеров до кластера:**

```
   много контейнеров     сегодня объединяются в ПОД      под живёт на узле      узлы образуют кластер
   ┌───────────┐         ┌───────────── Pod ─────────┐    ┌──────── Node ────────┐    ┌───────── Cluster ─────────┐
   │ app       │         │  контейнер app            │    │  ┌───┐ ┌───┐         │    │  control plane            │
   │ app+logs  │  ───►   │  контейнер sidecar (логи) │ ─► │  │pod│ │pod│  ─────►│   +  worker-узлы            │
   │ app+metr  │         │  общий IP · общий том      │    │  │pod│ │pod│         │   (каждый узел — машина)    │
   └───────────┘         └───────────────────────────┘    │  └─────┘              │                             │
                                                          └────────────────────────┘   └────────────────────────────┘
   Причина: раньше запускали «контейнер как сервис» — сейчас
   группой контейнеров управляют системно, как единым организмом.
```

### Попробуй сам
```shell
kubectl version --client        # версия клиента kubectl
kubectl version --client -o yaml # подробно
```

### Задание

1. Запиши своими словами: чем Kubernetes отличается от Docker Swarm и от простого `docker run -d`? В каком виде — контейнер или под — Kubernetes представляет твоё приложение?

### Самопроверка
**Ответ:**

- Kubernetes — оркестратор на уровне кластера (декларативное желаемое состояние), Docker — рантайм на уровне одной машины; Swarm — простой встроенный оркестратор внутри Docker.
- K8s работает с подами: группой контейнеров, разделяющих сеть/тома. Docker запускает одиночные контейнеры.
- `kubectl version --client` работает без кластера — это клиентская часть; для общения с сервером нужен работающий кластер.

---

## 2. Кластер: управляющий слой и рабочие узлы

**Теория.** Кластер состоит из двух частей:

**Control plane (управляющий слой)** — «мозг» кластера, обычно 1–3 машины:
- `kube-apiserver` — единственная точка входа (HTTPS-API). Все команды kubectl идут через него; он же авторизует запросы.
- `etcd` — хранилище состояния: все объекты (поды, сервисы, deployment-ы) лежат здесь.
- `kube-scheduler` — решает, на каком узле запустить новый под.
- `kube-controller-manager` — запускает контроллеры (ReplicaSet следит за числом подов, Deployment — за обновлениями…).

**Worker nodes (рабочие узлы)** — машины с приложениями:
- `kubelet` — агент узла: получает от apiserver задание, следит за подами на своём узле.
- `kube-proxy` — сетевые правила: правила маршрутизации к сервисам.
- контейнерный рантайм (containerd и т.п.) — собственно запускает контейнеры.

**Схема кластера:**

```
                     kubectl
                       │  HTTPS :6443
                       ▼
   ┌────────────────── CONTROL PLANE ────────────────────────────┐
   │   kube-apiserver  ·  etcd  ·  kube-scheduler                │
   │   kube-controller-manager                                   │
   └───────────────────────────┬─────────────────────────────────┘
                               │ «запусти/проверь/удали»
        ┌──────────────────────┴──────────────────────┐
        ▼                                             ▼
   ┌──────────── WORKER NODE 1 ────────────┐   ┌──────────────── WORKER NODE 2 ─────────────┐
   │   kubelet   ·  kube-proxy  ·  runtime │   │   kubelet   ·  kube-proxy  ·  runtime     │
   │   ┌───┐ ┌───┐  ┌───┐                 │   │   ┌───┐ ┌───┐  ┌───┐                      │
   │   │pod│ │pod│  │pod│   + ещё поды    │   │   │pod│ │pod│  │pod│                        │
   │   └───┘ └───┘  └───┘                 │   │   └───┘ └───┘  └───┘                        │
   └──────────────────────────────────────┘   └──────────────────────────────────────────────┘
   kubelet = «смотритель узла», kube-proxy = «маршрутизатор», runtime = «запускатель контейнеров»
```

### Попробуй сам

Запусти, когда есть кластер:
```shell
kubectl get nodes -o wide          # узлы кластера
kubectl get ns                     # пространства имён (kube-system и др.)
kubectl get pods -A -o wide        # поды во всех namespace (включая системные)
kubectl get componentstatuses      # (устарело) статус компонентов; современнее: kubectl get pods -n kube-system
```

### Задание

1. На рабочем кластере выполни `kubectl get nodes` и `kubectl get pods -A`. Найди в `kube-system` поды `etcd`, `kube-apiserver`, `kube-controller-manager`, `kube-scheduler` — это и есть компоненты control plane.

### Самопроверка
**Ответ:**

- `kubectl get nodes` показывает узлы и их роли (control-plane / worker).
- В `kube-system` живут системные поды: apiserver, etcd, scheduler, controller-manager («мозг»), а также компоненты сети/DNS (CoreDNS).
- Узлы с ролью `control-plane` обычно имеют taint (метку «не давать обычные поды»), поэтому приложения ставятся на worker-узлы.

---

## 3. Концепции Kubernetes с примерами

**Теория.** Kubernetes — это декларативная система: ты описываешь **желаемое состояние** в YAML, а контроллеры доводят реальность до него. Основные объекты:

| Объект | API (k8s 1.29+) | Что делает |
| --- | --- | --- |
| Node | `v1` | узел кластера (машина) |
| Pod | `v1` | группа контейнеров — минимальная единица |
| Deployment | `apps/v1` | декларативное управление подами + обновления (stateless) |
| Service | `v1` | стабильная точка доступа к подам (DNS + балансировка) |
| Ingress | `networking.k8s.io/v1` | маршрутизация внешнего трафика по host/path |
| Namespace | `v1` | изолированная «комната» для объектов |
| ConfigMap | `v1` | не секретная конфигурация (файлы/env) |
| Secret | `v1` | секретная конфигурация (токены, пароли) |
| Volume | `v1` | диск, подключённый к поду |
| PersistentVolume / PVC | `v1` | «кусок диска» и запрос на него |
| StatefulSet | `apps/v1` | управление приложениями с идентичностью (БД), кратно |
| HorizontalPodAutoscaler | `autoscaling/v2` | автоматическое масштабирование по метрикам |

**Схема — основные объекты в кластере:**

```
        ┌──────────────────────── Cluster ─────────────────────────┐
        │  Namespace: default                                      │
        │   ┌────────────┐   ┌────────────┐   ┌─────────────────┐  │
        │   │ Deployment │──▶│ ReplicaSet │──▶│ Pod × replicas  │  │
        │   └────────────┘   └────────────┘   └───────┬─────────┘  │
        │                                            │selector     │
        │   ┌────────────── ConfigMap ────────────▶  поды читают   │
        │   │  Service ◀──────────────────────────── конфиг         │
        │   │  Ingress ◀── внешний трафик                          │
        │   └───────────────────────────────────────────────────── │
        │  Volume / PVC ──► поды хранят данные                     │
        └──────────────────────────────────────────────────────────┘
```

**Минимальные примеры каждого объекта (копируй и храни):**

**Node:**
```yaml
apiVersion: v1
kind: Node
metadata:
  name: node-1
  labels:
    role: worker
```
*Узлы обычно не создают руками — они присоединяются к кластеру сами.*

**Pod:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
  labels:
    app: demo
spec:
  containers:
    - name: nginx
      image: nginx:1.27-alpine
      ports:
        - containerPort: 80
```

**Deployment:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deploy
  labels:
    app: demo
spec:
  replicas: 3
  selector:
    matchLabels:
      app: demo
  template:
    metadata:
      labels:
        app: demo
    spec:
      containers:
        - name: nginx
          image: nginx:1.27-alpine
          ports:
            - containerPort: 80
```

**Service (ClusterIP):**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-svc
spec:
  selector:
    app: demo
  ports:
    - port: 80
      targetPort: 80
```

**Ingress:**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ing
spec:
  ingressClassName: nginx
  rules:
    - host: demo.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: my-svc
                port:
                  number: 80
```

**Namespace:**
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: my-project
```

**ConfigMap:**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_ENV: production
  index.html: |
    <h1>Привет из ConfigMap!</h1>
```

**Secret:**
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
type: Opaque
stringData:          # удобная запись: kubectl сам закодирует в base64
  DB_PASSWORD: s3cret
```

**PersistentVolumeClaim:**
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

**StatefulSet (кратко):**
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: web       # обязательное поле: стабильные имена/сеть
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: nginx
          image: registry.k8s.io/nginx-slim:1.29
```

### Попробуй сам

Запусти, когда есть кластер:
```shell
kubectl apply -f pod.yaml
kubectl get pods -l app=demo
kubectl apply -f deployment.yaml
kubectl get deploy,rs,pods
kubectl apply -f service.yaml
kubectl get svc
```

### Задание

1. Прочитай второй YAML-пример (Deployment) и найди в нём три одинаковые строки `app: demo` — объясни, зачем каждая (подсказка: label, selector, template).

### Самопроверка
**Ответ:**

Три `app: demo`:
1. В `metadata.labels` Deployment — метка самого Deployment;
2. В `selector.matchLabels` — «по каким меткам искать поды» (ReplicaSet берёт это в работу);
3. В `template.metadata.labels` — метка, которую получит каждый созданный под.

**Правило:** `selector` обязателен и не может меняться после создания; шаблон пода (`template`) обязан иметь метки, совпадающие с селектором — иначе deployment откажет.

---

## 4. Установка локального кластера

**Теория.** Для обучения достаточно однократного кластера на одной машине. Три популярных варианта:

| Инструмент | Что даёт | Плюсы | Минусы |
| --- | --- | --- | --- |
| **kind** (Kubernetes IN Docker) | кластер-в-контейнерах Docker | быстро, дёшево, отлично для CI | нужен Docker; сеть чуть сложнее |
| **minikube** | настоящий «кластер под капотом» | поддерживает драйверы (docker/kvm/virtualbox), inngress и dashboard из коробки | тяжелее в запуске |
| **k3s** | легковесный Kubernetes (Rancher) | один бинарник, малый след, сертифицированный CNCF | кластер «по-настоящему» один узел по умолчанию |

Дополнительно нужен **kubectl** − клиент командной строки. Версия kubectl должна быть не старше на больше одной минорной версии от kube-apiserver.

### Попробуй сам

Установка kubectl (Linux):
```shell
# официальный способ
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```

Установка kind:
```shell
go install sigs.k8s.io/kind@latest        # если есть Go
# или через бинарник (амд64):
curl -Lo ./kind "https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64"
chmod +x ./kind && sudo mv ./kind /usr/local/bin/kind
kind create cluster                       # создать кластер kind-kind
kubectl config current-context            # → kind-kind
```

Установка minikube:
```shell
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start --driver=docker            # кластер в Docker
kubectl config current-context            # → minikube
minikube dashboard                        # веб-панель
```

Установка k3s:
```shell
curl -sfL https://get.k3s.io | sh -        # ставит k3s как систему и kubectl внутри
k3s kubectl get nodes                      # проверка
sudo cat /etc/rancher/k3s/k3s.yaml         # конфиг для kubectl с хоста
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
kubectl get nodes
```

Какой бы вариант ты ни выбрал, дальше команды одинаковы: kubectl работает с кластером через контекст.

### Задание

1. Установи один из трёх инструментов и kubectl, подними кластер, убедись в `kubectl get nodes` со статусом `Ready`.

### Самопроверка
**Ответ:**

- `kubectl get nodes` → `NAME… STATUS Ready` означает, что кластер доступен и kubectl настроен на правильный контекст.
- Если `kubectl` «не видит» кластер — посмотри контексты: `kubectl config get-contexts` и `kubectl config current-context`.
- По умолчанию у тебя локальный single-node кластер: разворачивать на нём — то же, что на «мини-продакшене»; для обучения этого достаточно.

---

## 5. kubectl: основные команды

**Теория.** kubectl — твой пульт к кластеру. Паттерн: `kubectl <действие> <ресурс> [флаги]`.

| Команда | Назначение |
| --- | --- |
| `kubectl get <res>` | список объектов (`-w` следить, `-o wide`/`-o yaml` формат, `-A` все namespace) |
| `kubectl describe <res> <имя>` | подробности + события (events) объекта |
| `kubectl logs <pod>` | логи (`-f` следить, `--previous` логи упавшего контейнера) |
| `kubectl exec -it <pod> -- <cmd>` | команда/шелл внутри контейнера пода |
| `kubectl apply -f <file>` | создать/обновить объекты из файла (декларативно) |
| `kubectl delete -f <file>` | удалить |
| `kubectl port-forward` | проброс порта на локальную машину |
| `kubectl config` | работа с контекстами |
| `kubectl rollout …` | управление обновлениями (разд. 7) |

Все объекты можно не создавать файлом, а генерировать командами (императивно) — удобно для обучения:
```shell
kubectl create deployment nginx --image=nginx:1.27-alpine --replicas=3
kubectl expose deployment nginx --type=NodePort --port=80 --name=nginx-svc
kubectl create namespace dev
```

### Попробуй сам

Запусти, когда есть кластер:
```shell
kubectl create deployment hello --image=nginx:1.27-alpine --replicas=3
kubectl get deployments                 # список
kubectl get pods -o wide                # + узлы и IP подов
kubectl get pods -w                     # следить в реальном времени (Ctrl+C — выход)
kubectl describe pod <имя-пода>         # события, образ, статус
kubectl logs deployment/hello           # логи всех подов deployment: (deploy/имя)
kubectl logs -f deployment/hello        # в реальном времени
kubectl exec -it <имя-пода> -- sh       # шелл внутри контейнера (nginx: alpine sh)
  # внутри: cat /etc/os-release && exit
kubectl port-forward deployment/hello 8080:80   # локальная проверка
  # в другом терминале открой http://localhost:8080
kubectl delete deployment hello
```

**Совет.** `kubectl get pod`, `kubectl get pods` и `kubectl get po` — синонимы (сокращения).

### Задание

1. Создай deployment из примера, посмотри, сколько подов появилось, опиши один под через `describe` и найди в выводе блоки `Events`, `Conditions`, `Containers`.

2. Выполни `kubectl get pods -o yaml` и найди поле `spec.containers[].image`. Сравни с `kubectl get deploy -o yaml` — обрати внимание на `spec.replicas` и `spec.selector`.

### Самопроверка
**Ответ:**

- `kubectl create deployment hello --replicas=3` создаёт deployment, который (через ReplicaSet) порождает 3 пода.
- `describe` показывает не только настройк, но и `Events` — последние события (Created, Started, Scheduled…); это главный источник для поиска проблем.
- `-o yaml` возвращает полный манифест объекта уже в кластере — удобно разбирать структуру (replicas, selector, containerPort…).

---

## 6. Pod и его жизненный цикл

**Теория.** Pod — минимальная единица Kubernetes. Внутри пода может быть несколько контейнеров (обычно один «приложение» + «sidecar»-контейнеры для логов/прокси). Все контейнеры пода делят один сетевой адрес и могут обмениваться через `localhost`, а также разделять тома.

Pod — эфемерен: падает узел — под пересоздаётся (другим, новым). Поэтому подами вручную почти не управляют — их создают через Deployment.

Фазы жизненного цикла:

```
   Pending ──► (планирование на узел)
      ▼
   ContainerCreating ──► (скачивание образа, запуск контейнеров)
      ▼
   Running ─────────────────────────┐
      │                             │
      ├─► Succeeded (успешное завершение)    └─► Failed (аварийное)
      ├─► CrashLoopBackOff (падает снова и снова)
      ├─► Evicted (вытеснен из-за нехватки ресурсов узла)
      └─► Terminating (завершается)
```

**Схема пода:**

```
   ┌────────────────── Pod ──────────────────┐
   │  10.244.0.5   (общий IP у всех контейнеров) │
   │  ┌────────────┐   ┌────────────┐         │
   │  │ контейнер  │   │ sidecar    │  ──►    │  общий localhost,
   │  │ app        │   │ (логи)     │         │  общий том, общая метка
   │  │ :8080      │   │            │         │  → «логически один юнит»
   │  └────────────┘   └────────────┘         │
   └───────────────────────────────────────────┘
     поды на узле: kubelet запускает & следит
```

### Попробуй сам
```shell
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: demo
spec:
  containers:
    - name: nginx
      image: nginx:1.27-alpine
      ports:
        - containerPort: 80
EOF
kubectl get pods -l app=demo          # спартанский статус
kubectl describe pod nginx-pod
kubectl logs nginx-pod
kubectl exec -it nginx-pod -- sh
  # внутри: hostname && exit
kubectl delete pod nginx-pod
```

### Задание

1. Создай под из примера, проверь фазу (`READY`/`STATUS`), загляни в него через `exec`, посмотри события в `describe`, потом удали.

### Самопроверка
**Ответ:**

- В `kubectl get pods` колонки: `READY 1/1` (контейнеров готово / всего), `STATUS Running`, `RESTARTS`.
- `exec` выполняет команду именно внутри контейнера; `hostname` покажет имя пода.
- Удаление пода из-под Deployment — норма: ReplicaSet сразу создаст замену. Удаление «голого» пода (без контроллера) — необратимо (пока не создашь заново).

---

## 7. Deployment: реплики, rollout, стратегии

**Теория.** Deployment — декларативное описание stateless-приложения: сколько реплик, какой образ, как обновляться. Он создаёт ReplicaSet (следит за числом подов), а тот — сами поды. Меняя манифест, ты описываешь «новое желаемое состояние», а контроллер плавно переводит кластер в него — это и есть **rollout**.

**Стратегии обновления:**

- `RollingUpdate` (по умолчанию): старые поды удаляются постепенно, новые поднимаются партиями — сервис не простаивает.
- `Recreate`: сначала удаляются все старые поды, потом создаются новые — простой, но чистая замена (для приложений, которым нельзя запускаться вдвоём).

**Схема rollout:**

```
        Deployment
            │  kubectl set image … / kubectl apply -f …
            ▼
   ReplicaSet v1 ─────────────►  ReplicaSet v2
   (былые поды)   RollingUpdate    (новые поды)
   [pod][pod][pod]   ─ 0→3    [pod][pod][pod]
     ↓  Recreate: сначала всё удалить, потом создать всё заново

   Управление:  kubectl rollout status/history/undo deploy/<имя>
```

### Попробуй сам
```shell
kubectl create deployment web --image=nginx:1.27-alpine --replicas=3
kubectl get deploy,rs,pods -l app=web

kubectl set image deployment/web nginx=nginx:1.27-alpine   # ничего не меняет? см. ниже
kubectl set image deployment/web nginx=nginx:1.29-alpine   # обновление версии
kubectl rollout status deployment/web                      # дождаться завершения
kubectl rollout history deployment/web                     # ревизии

kubectl rollout undo deployment/web                        # откат на предыдущую
kubectl rollout status deployment/web

kubectl scale deployment/web --replicas=5                  # масштабирование вручную
kubectl get pods -l app=web
kubectl delete deployment web
```

**Манифест со стратегией (копируй и храни):**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1        # максимум сколько реплик может быть недоступно
      maxSurge: 1              # на сколько реплик можно превысить желаемое
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: nginx
          image: nginx:1.27-alpine
          ports:
            - containerPort: 80
```

### Задание

1. Создай deployment `web` c 3 репликами, обнови образ через `kubectl set image`, наблюдай `kubectl get pods -w` во время обновления (появятся новые поды с более высоким суффиксом ревизии), затем откати.

2. В манифесте выше поменяй `strategy.type` на `Recreate`, перепримени по одному разу оба варианта и сравни поведение `kubectl get pods -w`: при Recreate старые поды исчезнут до появления новых.

### Самопроверка
**Ответ:**

- `kubectl set image deployment/web nginx=nginx:1.27-alpine`, когда образ и так тот же — триггеров не происходит (нет изменения); обновление версии явно запускает rollout.
- `RollingUpdate`: постепенная замена без простоя, есть небольшой «перекос» числа подов (maxSurge/maxUnavailable).
- `Recreate`: старые поды Terminating полностью до запуска новых — мгновенно, но с простоем.
- `kubectl rollout undo` возвращает предыдущую ревизию (можно `--to-revision=N`).

---

## 8. Service: ClusterIP, NodePort, LoadBalancer

**Теория.** Поды эфемерны: их IP меняются при пересоздании. **Service** — стабильная абстракция: у него постоянный IP/имя и балансировка запросов на поды, отобранные по селектору (label selector).

Три главных типа:

- **ClusterIP** (по умолчанию) — виртуальный IP *внутри кластера*; доступен только изнутри. Для связи подов/сервисов друг с другом.
- **NodePort** — ClusterIP + публичный порт *на каждом узле* (30000–32767). Достаточно для локальной отладки.
- **LoadBalancer** — NodePort + внешний балансировщик (в облаке автоматически выделяет внешний IP). Для продакшн-доступа.

**Схемы:**

```
  ClusterIP (внутри кластера)
   [pod?]  ──►  Service 10.96.0.10:80  ──►  [pod][pod][pod]  (по меткам)

  NodePort (наружу через порт узла)
   Хост:30080  ──►  Service ClusterIP  ──►  [pod][pod][pod]

  LoadBalancer (облачный)
   Внешний IP/LB  ──►  NodePort  ──►  Service  ──►  поды
```

### Попробуй сам
```shell
kubectl create deployment web --image=nginx:1.27-alpine --replicas=3
kubectl expose deployment web --type=ClusterIP --port=80 --name=web-svc
kubectl get svc web-svc -o wide          # CLUSTER-IP 10.x, SELECTOR app=web
kubectl get endpoints web-svc            # IP подов за сервисом

# внутри кластера проверим через временный под
kubectl run curl-test --rm -it --image=curlimages/curl -- sh
  # curl http://web-svc            # → Welcome to nginx!  (имя сервиса = DNS)
  # exit

kubectl delete svc web-svc
kubectl expose deployment web --type=NodePort --port=80 --name=web-svc
kubectl get svc web-svc                # PORT(S): 80:31923/TCP
# открой в браузере http://<IP-узла>:31923  (для kind: kubectl port-forward svc/web-svc 8080:80)
kubectl delete service web-svc
```

**Манифесты трёх сервисов (копируй и храни):**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-clusterip
spec:
  selector: { app: web }
  ports:
    - port: 80
      targetPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: web-nodeport
spec:
  type: NodePort
  selector: { app: web }
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30080        # диапазон 30000-32767 (можно не указывать)
---
apiVersion: v1
kind: Service
metadata:
  name: web-lb
spec:
  type: LoadBalancer
  selector: { app: web }
  ports:
    - port: 80
      targetPort: 80
```

### Задание

1. Разверни deployment `web`, создай сервис ClusterIP и с временного пода (`kubectl run curl-test --rm -it --image=curlimages/curl -- sh`) достучись до него по имени `web-svc`. Потом переведи сервис в NodePort и открой его с хоста (в kind/minikube через port-forward).

### Самопроверка
**Ответ:**

- Service выбирает поды по `selector`; список «актуальных» подов виден в `kubectl get endpoints`.
- ClusterIP доступен только внутри кластера; DNS-имя сервиса — `<имя>.<namespace>.svc.cluster.local`, кратко `web-svc`.
- NodePort публикует порт на всех узлах сразу (30000-32767); LoadBalancer — для облака, где он выдаёт внешний IP.
- Если `curl http://web-svc` не отвечает — сверь `selector` сервиса с метками подов (`kubectl get pods --show-labels`).

---

## 9. Ingress и ingress-контроллер

**Теория.** NodePort/LoadBalancer дают по сервису на приложение. **Ingress** — «уровень 7»: по одному внешнему IP маршрутизирует запросы по хостам (`host`) и путям (`path`) на разные сервисы (например, `/api/` → backend, `/` → frontend).

Важный нюанс: сам по себе Ingress — просто *правила*. Реальную маршрутизацию выполняет **ingress-контроллер** (например, ingress-nginx, входит в состав kind/minikube как дополнение). Без установленного контроллера правил Ingress некому исполнять.

**Схема:**

```
        ┌──────────────┐
        │ hello.local  │  (DNS → IP контроллера)
        └──────┬───────┘
               ▼
   ┌───────────────── INGRESS (networking.k8s.io/v1) ─────────────────┐
   │  ingressClassName: nginx                                         │
   │  host: hello.local                                               │
   │      path /api/   ──►  Service api-backend   ──► [pod][pod]      │
   │      path /       ──►  Service web-front     ──► [pod][pod]      │
   └───────────────────────────────────────────────────────────────────┘
   правила Ingress тривиальны, данные идёт через ingress-контроллер (nginx)
```

### Попробуй сам
```shell
# 1. Контроллер (в kind обычно ставят отдельно, в minikube встроен):
#    kind:  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
#    minikube:  minikube addons enable ingress

kubectl create deployment web --image=nginx:1.27-alpine --replicas=2
kubectl expose deployment web --port=80 --name=web

kubectl apply -f - <<'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ing
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
    - host: hello.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: web
                port:
                  number: 80
EOF

kubectl get ingress web-ing            # ADDRESS, HOSTS: hello.local
# в kind: пробрось порт контроллера:
kubectl port-forward -n ingress-nginx deployment/ingress-nginx-controller 8080:80
# в minikube: достаточно minikube tunnel (LoadBalancer) или port-forward
echo "127.0.0.1 hello.local" | sudo tee -a /etc/hosts
curl -H "Host: hello.local" http://127.0.0.1:8080/    # → Welcome to nginx!
```

### Задание

1. Установи/включи ingress-контроллер, создай два deployment (nginx в /, httpd в /api/), два сервиса и один Ingress с двумя правилами путей, проверь оба curl-запроса.

### Самопроверка
**Ответ:**

- Без `ingressClassName` и установленного контроллера Ingress не работает (для minikube/kind — отдельный шаг).
- `curl -H "Host: hello.local"` — имитация браузера: DNS имя обязано совпасть с `rules[].host`.
- `pathType: Prefix` — сопоставление по префиксу пути; `Exact` требует точного совпадения.
- Контроллер отдаёт 404, если ни одно правило не подошло; ссылку на контроллер смотри в `kubectl get ns`.

---

## 10. ConfigMap и Secret

**Теория.** Настройки не должны «зашиваться» в образ — их передают при деплое:

- **ConfigMap** — не секретные данные (конфиги, `.ini`, строки, HTML-шаблоны).
- **Secret** — чувствительные данные (пароли, токены, ключи). В API хранятся в base64 (это не шифрование, а кодирование!) — в продакшене включают шифрование etcd и внешние секрет-хранилища.

Оба можно отдать поду двумя способами:
- как **переменные окружения** (`env.valueFrom.configMapKeyRef` / `secretKeyRef`);
- как **файлы** (монтирование тома из ConfigMap/Secret).

**Схема:**

```
     ConfigMap:  APP_ENV=production, index.html          (не секретно)
     Secret:     DB_PASSWORD=s3cret                       (base64 в API)

              env.valueFrom  ──►  контейнер читает переменную
     под ────►
              volume (configMap/secret) ──►  файлы в контейнере
```

### Попробуй сам
```shell
kubectl create configmap app-config --from-literal=APP_ENV=production --from-literal=LOG_LEVEL=info
kubectl create secret generic app-secret --from-literal=DB_PASSWORD=s3cret
kubectl get configmap app-config -o yaml
kubectl get secret app-secret -o yaml        # DB_PASSWORD: czNjcmV0  (base64)
echo 'czNjcmV0' | base64 -d                  # → s3cret

kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: cfg-pod
spec:
  containers:
    - name: nginx
      image: nginx:1.27-alpine
      env:
        - name: APP_ENV
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: APP_ENV
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: app-secret
              key: DB_PASSWORD
      volumeMounts:
        - name: app-html
          mountPath: /usr/share/nginx/html/index.html
          subPath: index.html
          readOnly: true
  volumes:
    - name: app-html
      configMap:
        name: app-config
        items:
          - key: index.html
            path: index.html
EOF
kubectl exec cfg-pod -- printenv APP_ENV DB_PASSWORD   # production / s3cret
kubectl delete pod cfg-pod
```

**Манифесты ConfigMap и Secret с несколькими ключами:**

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_ENV: production
  LOG_LEVEL: info
  index.html: |
    <h1>Привет из ConfigMap</h1>
```
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
type: Opaque
stringData:
  DB_PASSWORD: s3cret        # CLI kube применит base64 сам
```

### Задание

1. Создай ConfigMap с двумя литералами, Secret с паролем, под, в контейнере которого есть и переменные окружения, и монтируемый файл (index.html). Проверь через `exec`: `printenv` и `cat index.html`.

### Самопроверка
**Ответ:**

- `kubectl get secret -o yaml` показывает значения в base64; `stringData` на входе катается в `data` — в подах тоже есть расшифровка? Нет: Secret хранится в кластере закодированным, но контейнер получает его в расшифрованном виде.
- Монтирование файла из ConfigMap требует `items` для одного конкретного ключа и `subPath` — иначе смонтируется каталог и перекроет существующую директорию целиком.
- После изменения ConfigMap поды не пересоздаются автоматически; обновление применяется перезапуском/`kubectl rollout restart deployment/…`.

---

## 11. Хранение данных: Volume, PV, PVC

**Теория.** Тома в Kubernetes бывают двух уровней:

- **Volume** — смонтирован в конкретный pod (emptyDir — временный, вместе с подом; hostPath — папка узла; проекция ConfigMap/Secret — см. разд. 10).
- **PersistentVolume (PV)** — «кусок диска»: подготовлен администратором (или автоматически, динамически через StorageClass, как в облаках).
- **PersistentVolumeClaim (PVC)** — запрос пода на хранение: «дай мне 1 Gi с доступом ReadWriteOnce». K8s связывает подходящий PV с PVC (или создаёт новый PV динамически), а под монтирует его.

**Схема:**

```
   PersistentVolume (диск, готов администратором/StorageClass)
           ▲   bind (связывание подходящих)
   PersistentVolumeClaim — «запрос: 1 Gi, RWO»
           ▲   mount
   [Pod] ──►  контейнер: /var/lib/mydata
```

### Попробуй сам

В kind/minikube встроен StorageClass «local-path»/«standard» — PVC создастся динамически:
```shell
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
EOF
kubectl get pvc data-pvc               # STATUS Bound — хороший знак
kubectl get pv                         # связанный PersistentVolume

kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: pvc-pod
spec:
  containers:
    - name: nginx
      image: nginx:1.27-alpine
      volumeMounts:
        - name: data
          mountPath: /data
  volumes:
    - name: data
      persistentVolumeClaim:
        claimName: data-pvc
EOF
kubectl exec pvc-pod -- sh -c 'echo сохранено > /data/note.txt && cat /data/note.txt'
kubectl delete pod pvc-pod
```

**Манифесты (копируй и храни)** — пример статического PV (hostPath, годится только для одноузлового кластера/изучения):

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-local
spec:
  storageClassName: manual
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /mnt/k8s-data
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-pvc
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

### Задание

1. Создай PVC с динамической подготовкой, под, запиши файл в `/data`, удали под и создай новый под с тем же PVC — файл должен быть на месте.

### Самопроверка
**Ответ:**

- PVC со статусом `Bound` означает, что с ним связан PV (динамический или статический).
- Данные переживают пересоздания подов, пока жив PVC; при удалении PVC (и политике Reclaim/Delete) данные исчезают.
- PVC монтируется в контейнер через `volumes.persistentVolumeClaim` + `volumeMounts`.
- Для stateful-сервисов (БД) обычно используют StatefulSet (см. п. 3): каждый под получает свой стабильный PVC.

---

## 12. Сеть: поды, сервисы, DNS

**Теория.** В кластере:

- каждый под имеет собственный IP (кластерная сеть контейнеров);
- поды *одного узла* и поды *разных узлов* общаются напрямую (плагин CNI, например Calico/Cilium);
- **Service** даёт стабильное имя и DNS: `<имя>.<namespace>.svc.cluster.local`;
- внутри одного namespace достаточно короткого имени (`web`) — поды так и обращаются: `curl http://web:80`;
- DNS всей этой сетью предоставляет CoreDNS (его поды живут в `kube-system`).

**Схема устройство DNS:**

```
   [под api]  ──►  "web"  ──► (CoreDNS) ──►  Service web (10.96.0.20)  ──►  [web pod][web pod]
                    │ полное имя: web.default.svc.cluster.local
                    ▼
   имена резолвятся только для того namespace, где идёт запрос,
   полное имя работает из любого места кластера.
```

### Попробуй сам
```shell
kubectl create deployment web --image=nginx:1.27-alpine --replicas=2
kubectl expose deployment web --port=80
kubectl get svc,ep,pods -o wide

kubectl run testpod --rm -it --image=curlimages/curl -- sh
  # nslookup web.default.svc.cluster.local          # DNS-ответ из CoreDNS
  # nslookup web                                    # кратко: тоже работает
  # curl http://web:80     # → nginx (балансировка на 2 пода)
  # exit
```

### Задание

1. Из временного пода проверь DNS короткого и полного имени сервиса, а также `getent hosts` для IP пода (они видят друг друга по pod-адресам напрямую).

### Самопроверка
**Ответ:**

- Короткое имя (`web`) работает внутри того же namespace; из другого namespace используй `web.<namespace>.svc`.
- CoreDNS — DNS-сервер кластера (под в `kube-system`); если поды не резолвят имена — проверь, что CoreDNS работает и сетевой плагин CNI.
- Service балансирует трафик на поды по меткам; `kubectl get endpoints` показывает актуальные IP подов за сервисом.

---

## 13. Namespace для изоляции

**Теория.** Namespace (пространство имён) — «комната» для объектов: те же имена (svc `web`, deployment `web`) могут существовать в разных namespace, не конфликтуя. Применяется для окружений (dev/prod), команд, мультитенантности и политик. Большинство команд kubectl по умолчанию работает с namespace `default` (флаг `-n <имя>`).

**Схема изоляции:**

```
   ┌── namespace: dev ───────────┐   ┌── namespace: prod ──────────┐
   │  svc/web (10.96.0.10)       │   │  svc/web (10.96.0.20)       │   одинаковые имена,
   │  deploy/web · pod/api       │   │  deploy/web · pod/db        │   изолированные сети,
   │  networkpolicy: iron        │   │  quota: лимиты ресурсов     │   свои правила
   └─────────────────────────────┘   └─────────────────────────────┘
```

### Попробуй сам
```shell
kubectl create namespace dev
kubectl get namespaces
kubectl create deployment web -n dev --image=nginx:1.27-alpine
kubectl get deploy -A              # всё во всех namespace
kubectl get deploy -n dev
kubectl delete deployment web -n dev
kubectl delete namespace dev
```

**Манифест namespace:**
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: dev
  labels:
    project: learning
```

### Задание

1. Создай namespace `dev`, deployment внутри него, посмотри, что из `default` его не видно без `-n dev`, удали всё.

### Самопроверка
**Ответ:**

- `kubectl get deploy` без флага показывает только `default`; `-A` или `--all-namespaces` показывает все.
- К системным namespace (`kube-system`, `kube-public`) лучше не лезть без надобности.
- Для управления лимитами в namespace: `ResourceQuota` (суммарные ресурсы) и `LimitRange` (границы на под) — см. литературу.

---

## 14. Ресурсы requests/limits и автоподмасштабирование

**Теория.** Чтобы scheduler правильно размещал поды, а ограничения защищали соседей, каждый контейнер объявляет:

- **requests** — гарантированное количество ресурса (scheduler ищет узел, где столько свободно);
- **limits** — жёсткий потолок (при превышении CPU — троттлинг, память — OOM-kill).

Единицы: CPU в ядрах (`0.5`, `500m` = 500 milliCPU), память (`256Mi`, `1Gi`).

**HorizontalPodAutoscaler (HPA)** (`autoscaling/v2`) автоматически меняет число реплик Deployment в пределах `minReplicas…maxReplicas` по наблюдаемым метрикам (например, средняя загрузка CPU). Для работы HPA нужен `metrics-server` (в minikube/kind ставится аддоном или через манифест).

**Схема:**

```
                 metrics-server  (собирает метрики подов)
                        ▲
                        │ CPU 60% > target 50%
   HPA (autoscaling/v2) ┤  min:2  max:10
        │               ▼
        ▼        recompute replicas
   Deployment ──► [pod]×2 ──► [pod]×5 ──► [pod]×10 …
```

### Попробуй сам
```shell
kubectl top nodes / kubectl top pods            # текущее потребление
kubectl apply -f - <<'EOF'
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: web
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 50
EOF
kubectl get hpa                      # TARGETS 0%/50%
```

**Манифест Deployment с ресурсами (копируй и храни):**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: nginx
          image: nginx:1.27-alpine
          resources:
            requests:
              cpu: "100m"
              memory: "128Mi"
            limits:
              cpu: "500m"
              memory: "256Mi"
```

### Задание

1. Добавь ресурсы к deployment, создай HPA по CPU (target 50%), прогони нагрузку `kubectl run load --image=busybox -- /bin/sh -c 'while true; do wget -q -O- http://web; done'` (потом останови под: `kubectl delete pod load`) и наблюдай рост реплик.

### Самопроверка
**Ответ:**

- Без requests/limits поды могут упасть, когда узел перегружен; HPA считает по requests-измерениям.
- `kubectl get hpa` показывает `TARGETS <текущее%>/<target%>`; рост нагрузки поднимает реплики до `maxReplicas`.
- Нюанс: если метрик нет (metrics-server не установлен) — HPA не считает, `TARGETS <unknown>/50%`.
- Для стабильных dev/прод: ставим requests близко к реальному потреблению, limits — с запасом.

---

## 15. Проверки здоровья: probes

**Теория.** Чтобы кластер сам чинил приложения, контейнеру объявляют три проверки:

- **startupProbe** — «приложение ещё стартует»: даёт время инициализации, особой для лёгких приложений не нужно;
- **readinessProbe** — «готов принимать трафик»: пока не пройдёт, Service не шлёт трафик на этот под (endpoint исключается);
- **livenessProbe** — «процесс жив»: если провалилась (при N подряд неудач), kubelet перезапускает контейнер.

Механизмы проверки: `httpGet` (HTTP-запрос по path/port), `tcpSocket` (открытие TCP), `exec` (команда, exit 0 = ок). Параметры: `initialDelaySeconds`, `periodSeconds`, `timeoutSeconds`, `failureThreshold`.

**Схема:**

```
   контейнер стартует
        │
        ▼
   startupProbe ──(стартует долго?)──► пройдена? нет ──► ждём ещё
        │ да                                    │
        ▼                                       ▼
   readinessProbe ──► пройдена? нет ──► Service НЕ шлёт трафик
        │ да                        │
        ▼                           ▼
   livenessProbe  ──► провал N раз ──► kubelet перезапускает контейнер
        │
   трафик идёт (readiness+startup пройдены)
```

### Попробуй сам
```shell
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: probes-demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: probes
  template:
    metadata:
      labels:
        app: probes
    spec:
      containers:
        - name: nginx
          image: nginx:1.27-alpine
          startupProbe:
            httpGet: { path: /, port: 80 }
            failureThreshold: 30
            periodSeconds: 10
          readinessProbe:
            httpGet: { path: /, port: 80 }
            initialDelaySeconds: 3
            periodSeconds: 5
          livenessProbe:
            httpGet: { path: /, port: 80 }
            initialDelaySeconds: 10
            periodSeconds: 10
EOF
kubectl get pods -w                    # READY 2/2
kubectl describe pod <pod>             # в Conditions: Ready=True
# проверь сбой: httpGet вернёт 500, если внутри приложения ответит ошибкой;
# для эксперимента: kubectl exec <pod> -- rm /usr/share/nginx/html/index.html
```

### Задание

1. Добавь все три probe к nginx-deployment, убедись, что поды получают `Ready=True`, а после удаления страницы через `exec` контейнер всё же продолжает отвечать (nginx вернёт код без файла) — и подумай, почему `livenessProbe httpGet /` сработает только при коде ≥ 500.

### Самопроверка
**Ответ:**

- `readinessProbe` убирает под из балансировки Service при недоступности, но не убивает его; `livenessProbe` — перезапускает контейнер.
- httpGet считается успешным при 2xx/3xx коде; 404 — успех с точки зрения liveness (важна доступность, не содержимое).
- Правильная картина: `/healthz` возвращает 200, пока приложение готово; иначе 503 — тогда и traffic отводится (readiness), и при долгой неработоспособности контейнер перезапускается (liveness).

---

## 16. Деплой приложения: полный пример

**Теория.** Собираем всё воедино: Deployment + ConfigMap + Service + Ingress — небольшой сайт «Привет из Kubernetes», настраиваемый через ConfigMap, с готовностью/здоровьем, доступный по имени `hello.local`.

### Попробуй сам

Создай файлы в папке `~/k8s-demo`.

**1. ConfigMap** — `configmap.yaml` (приветственный HTML + `API_URL`):
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: hello-config
data:
  API_URL: https://example.com
  index.html: |
    <!DOCTYPE html>
    <html>
      <head><meta charset="utf-8"><title>Kubernetes demo</title></head>
      <body>
        <h1>Привет из Kubernetes!</h1>
        <p>Под: __POD_NAME__</p>
        <p>API_URL: __API_URL__</p>
      </body>
    </html>
```

**2. Deployment** — `deployment.yaml`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-web
  labels:
    app: hello-web
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  selector:
    matchLabels:
      app: hello-web
  template:
    metadata:
      labels:
        app: hello-web
    spec:
      containers:
        - name: nginx
          image: nginx:1.27-alpine
          ports:
            - containerPort: 80
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
          resources:
            requests: { cpu: "100m", memory: "64Mi" }
            limits: { cpu: "250m", memory: "128Mi" }
          readinessProbe:
            httpGet: { path: /, port: 80 }
            initialDelaySeconds: 3
            periodSeconds: 5
          livenessProbe:
            httpGet: { path: /, port: 80 }
            initialDelaySeconds: 10
            periodSeconds: 10
          volumeMounts:
            - name: hello-html
              mountPath: /usr/share/nginx/html/index.html
              subPath: index.html
              readOnly: true
      volumes:
        - name: hello-html
          configMap:
            name: hello-config
            items:
              - key: index.html
                path: index.html
```

**3. Service** — `service.yaml`:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: hello-svc
spec:
  selector:
    app: hello-web
  ports:
    - port: 80
      targetPort: 80
```

**4. Ingress** — `ingress.yaml`:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello-ing
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
    - host: hello.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: hello-svc
                port:
                  number: 80
```

Развёртывание и проверка:
```shell
kubectl apply -f configmap.yaml -f deployment.yaml -f service.yaml -f ingress.yaml
kubectl get cm,deploy,rs,pods,svc,ing -o wide
kubectl rollout status deployment/hello-web
kubectl get pods -w
kubectl get ingress

# доступ: правильно настроить DNS + порт контроллера
echo "127.0.0.1 hello.local" | sudo tee -a /etc/hosts
kubectl port-forward -n ingress-nginx deployment/ingress-nginx-controller 8080:80
# в другом терминале:
curl -H "Host: hello.local" http://127.0.0.1:8080/     # → «Привет из Kubernetes!»
```

### Задание

1. Разверни приложение из примеров, открой страницу с curl (пробрасывая порт контроллера), затем обнови ConfigMap — поменяй текст приветствия — и перезапусти поды: `kubectl rollout restart deployment/hello-web`. Убедись, что страница изменилась.

### Самопроверка
**Ответ:**

- `kubectl apply` создаёт/обновляет все объекты; `rollout status` ждёт, когда новые поды станут Ready.
- ConfigMap → volume: файл `index.html` перезаписывает стандартную страницу nginx в каждом поде.
- После изменения ConfigMap контейнеры не обновят файл сами по себе — поэтому `kubectl rollout restart` пересоздаёт поды и монтирует свежую копию.
- Ingress без внешнего DNS проверяется через заголовок `Host: hello.local` + port-forward на контроллер (или `minikube tunnel`).

---

## 17. Проекты-практикумы

Пошаговые проекты от простого к сложному. Пометки «запусти, когда есть кластер» означают: манифесты храни и применяй, когда поднимешь локальный кластер (разд. 4).

### Проект 1. Первый deployment и доступ к нему

1. Подними кластер (kind/minikube/k3s).
2. `kubectl create deployment hello --image=nginx:1.27-alpine --replicas=3`.
3. `kubectl get pods -w` — дождись `Ready 3/3`.
4. `kubectl expose deployment hello --type=NodePort --port=80 --name=hello-svc`.
5. `kubectl get svc` — найди порт `80:3xxxx/TCP`.
6. В kind: `kubectl port-forward svc/hello-svc 8080:80`; в минikube: `minikube service hello-svc`. Открой в браузере.

### Проект 2. Своё Flask-приложение в кластере

1. Собери образ и запушь в реестр: `docker build -t yourname/flash-demo:v1 . && docker push yourname/flash-demo:v1` (Dockerfile — из учебника Docker).
2. `kubectl create deployment flask --image=yourname/flash-demo:v1 --port=5000`.
3. `kubectl expose deployment flask --port=5000 --target-port=5000 --type=NodePort`.
4. Проверь через `kubectl port-forward svc/flask 5000:5000` + `curl localhost:5000`.
5. Масштабируй: `kubectl scale deployment flask --replicas=4`.

### Проект 3. Обновление и откат (деплой как профессионал)

1. Deployment `web` с `nginx:1.27-alpine` (3 реплики).
2. `kubectl set image deployment/web nginx=nginx:1.29-alpine`, наблюдай `kubectl get pods -w`.
3. `kubectl rollout history deployment/web` — две ревизии.
4. `kubectl rollout undo deployment/web --to-revision=1` — откат.

### Проект 4. ConfigMap-конфигурация + probes (готовый шаблон)

1. Возьми полный пример раздела 16, но сделай свой HTML (своё имя), свой `POD_NAME`.
2. Прогони `kubectl rollout restart deployment/hello-web` после правки ConfigMap.
3. Добавь `startupProbe` c `periodSeconds: 2` и проверь, что при `failureThreshold` мало (< времени старта) контейнер уходит в `CrashLoopBackOff` при подключении тяжёлого init.

### Проект 5. Хранилища: БД с PVC

1. Создай `namespace db`.
2. PVC `db-pvc` 1Gi (динамический, твой StorageClass).
3. Deployment `postgres` (образ `postgres:17-alpine`, env `POSTGRES_PASSWORD` из Secret) с PVC-монтированием в `/var/lib/postgresql/data`.
4. Service + порт, проверь `psql` из временного пода.
5. Удали под postgres — данные живы; обнови том — одинаковы.

### Проект 6. HPA под нагрузкой

1. Deployment `web` (replicas: 1, requests.cpu `100m`, limits.cpu `500m`).
2. HPA `min 1, max 8, target 50%`.
3. Нагрузи: `kubectl run load --image=busybox -- sh -c 'while true; do wget -q -O- http://web; done'` (останови через `kubectl delete pod load` через минуту).
4. `kubectl get hpa -w` — увидишь рост реплик и снижение после остановки нагрузки.

### Проект 7. Ingress-маршрутизация двух приложений

1. Два deployment: `front` (nginx) и `api` (httpd).
2. Два сервиса (ClusterIP).
3. Один Ingress: `front.example` и `api.example` (или `/` и `/api/` через rewrite).
4. Проверь оба `curl -H "Host: …"` — каждый попадает в свой бэкенд.

---

## 18. Литература и ссылки

Официальная документация (русская и английская версии):
- https://kubernetes.io/ru/docs/concepts/overview/what-is-kubernetes/ — «Что такое Kubernetes» (RU)
- https://kubernetes.io/ru/docs/concepts/overview/components/ — компоненты кластера (RU)
- https://kubernetes.io/ru/docs/concepts/architecture/nodes/ — узлы (RU)
- https://kubernetes.io/ru/docs/concepts/workloads/pods/ — поды (RU)
- https://kubernetes.io/docs/concepts/workloads/controllers/deployment/ — Deployment (EN)
- https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/ — StatefulSet (EN)
- https://kubernetes.io/docs/concepts/services-networking/service/ — Service (EN)
- https://kubernetes.io/docs/concepts/services-networking/ingress/ — Ingress (EN)
- https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/ — DNS (EN)
- https://kubernetes.io/ru/docs/concepts/overview/working-with-objects/namespaces/ — пространства имён (RU)
- https://kubernetes.io/docs/concepts/configuration/configmap/ — ConfigMap (EN)
- https://kubernetes.io/docs/concepts/configuration/secret/ — Secret (EN)
- https://kubernetes.io/docs/concepts/storage/persistent-volumes/ — PV/PVC (EN)
- https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/ — HPA пошагово (EN)
- https://kubernetes.io/ru/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ — probes (RU)
- https://kubernetes.io/ru/docs/tasks/debug/debug-application/get-shell-running-container/ — как залезть в контейнер (RU)
- https://kubernetes.io/ru/docs/setup/learning-environment/minikube/ — minikube (RU)
- https://kubernetes.io/ru/docs/setup/learning-environment/kind/ — kind (RU)
- https://kubernetes.io/ru/docs/tasks/tools/install-kubectl/ — установка kubectl (RU)

Инструменты:
- https://kind.sigs.k8s.io/ — официальный сайт kind
- https://minikube.sigs.k8s.io/docs/ — официальный сайт minikube
- https://k3s.io/ — легковесный Kubernetes (Rancher)
- https://kubernetes.io/ru/docs/setup/learning-environment/ — среда обучения (RU)

Проверено на: kubectl-client 1.36 (k3s 1.36), Docker Engine 29. Все манифесты используют стабильные API k8s 1.29+ (`apps/v1`, `v1`, `networking.k8s.io/v1`, `autoscaling/v2`).
