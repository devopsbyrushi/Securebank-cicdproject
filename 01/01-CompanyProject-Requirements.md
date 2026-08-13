# FlipkartEcommerce — DevOps Architecture & Delivery Plan

*Prepared by the RushiInfotech DevOps team*

---

## 1. Project Context

RushiInfotech has been engaged to build and automate **FlipkartEcommerce**, an
online marketplace where customers browse products, place orders, and pay online.
It is the team's top-priority engagement and has an aggressive target: a
production-ready launch in roughly one month.

The platform is built as a set of independently deployable services rather than a
single monolith, so the DevOps setup has to make it easy to build, test, and ship
many services through one consistent, automated path.

---

## 2. Guiding Principles

A few decisions were locked in up front and shape everything else:

- **Cloud first, GCP now:** the platform launches on Google Cloud Platform
- **Everything as code:** infrastructure is never clicked together by hand — it is
  described in Terraform and version-controlled.
- **Clean separation of concerns:** application code and infrastructure/config
  code live in different repositories and have different owners.
- **Database is IaC-only:** the managed MySQL database is created and changed
  exclusively through Terraform; configuration tooling (Ansible) is deliberately
  kept away from it.
- **Reviewed changes only:** the `main` branch of every repo is protected, so
  nothing merges without review.

---

## 3. Technology Decisions

Rather than a single stack list, here is what each layer uses and why.

| Area | Choice | Purpose |
|------|--------|---------|
| Cloud | GCP  | Host all infrastructure and workloads |
| Provisioning | Terraform | Declare and manage every cloud resource |
| Configuration | Ansible | Install/configure tools on the build & scan hosts (not the DB) |
| Source control | GitHub | Version control with protected branches |
| CI/CD engine | Jenkins + shared libraries | Reusable build/test/deploy pipelines |
| Backend build | Maven | Compile & package the Java services |
| Frontend build | npm | Build the React apps |
| Artifacts | JFrog Artifactory | Store build artifacts and Docker images |
| Containers | Docker | Package each service as an image |
| Orchestration | Kubernetes (GKE) | Run and scale the containers |
| Deployment | Helm | Template and release apps onto GKE |
| Code quality | SonarQube | Static analysis / quality gates in the pipeline |
| Database | Cloud SQL (MySQL) | Managed relational data store |
| Monitoring | Prometheus + Grafana | Collect metrics, dashboards, alerts |

---

## 4. Application Architecture

The backend is a collection of **Java Spring Boot** microservices; the customer
and seller interfaces are **React** apps. Each service is its own repository so it
can be built and deployed on its own. Repositories use an `fec-` prefix
(*FlipkartEcommerce*).

**Platform / cross-cutting services**

| Repository | Responsibility |
|------------|----------------|
| `fec-login` | Service discovery / registry |
| `fec-gateway` | API gateway — routing, auth checks, rate limiting |
| `fec-config` | Centralized configuration server |
| `fec-auth` | Login, tokens, and authorization |

**Core commerce services**

| Repository | Responsibility |
|------------|----------------|
| `fec-users` | Customer profiles and accounts |
| `fec-products` | Product catalog and details |
| `fec-search` | Search, filtering, and sorting |
| `fec-cart` | Shopping cart and saved items |
| `fec-orders` | Order placement, history, and lifecycle |
| `fec-payments` | Checkout and payment-gateway integration |
| `fec-inventory` | Stock levels and warehouse availability |
| `fec-shipping` | Delivery scheduling and shipment tracking |

**Engagement services**

| Repository | Responsibility |
|------------|----------------|
| `fec-reviews` | Ratings and product reviews |
| `fec-recommendations` | Personalized product suggestions |
| `fec-notifications` | Email / SMS / push notifications |

**Frontend (React)**

| Repository | Responsibility |
|------------|----------------|
| `fec-web` | Customer-facing storefront |
| `fec-seller` | Seller / admin portal |

> **Practice tip:** you don't need all of these to learn the pipeline. A solid
> starter subset is `fec-eureka`, `fec-gateway`, `fec-users`, `fec-products`,
> `fec-cart`, `fec-orders`, and `fec-web` — enough to exercise discovery, routing,
> several backends, and a frontend end-to-end.

---

## 5. Repository Strategy

Two kinds of repositories, kept separate on purpose:

- **Application repositories** — one per service (the `fec-*` list above), each
  owned by the development team.
- **Infrastructure repository** — a single repo that holds the platform plumbing:
  - Terraform for GCP resources and the Cloud SQL database.
  - Ansible playbooks for configuring the Jenkins, SonarQube, and Docker hosts.

Every repository protects its `main` branch so changes require review before merge.

---

## 6. Infrastructure (Terraform-Provisioned)

Terraform stands up the full environment on GCP:

- Compute hosts for the **Jenkins master**, **Jenkins agent(s)**, **SonarQube**,
  and **Docker**.
- A **Cloud SQL (MySQL)** instance — provisioned and updated only through
  Terraform.
- A **GKE cluster** to run the application workloads.

Once Terraform creates the hosts, **Ansible** takes over their configuration —
installing and wiring up Jenkins, SonarQube, and Docker — with the sole exception
of the database, which stays purely Terraform-managed.

---

## 7. Delivery Pipeline (CI/CD)

Jenkins drives delivery, and **shared libraries** keep the pipeline logic in one
place so every `fec-*` repo reuses the same stages instead of copying them.

A typical run moves a change through these stages:

```
 Checkout ─► Build ─► Code Scan ─► Package ─► Publish ─► Provision ─► Deploy ─► Verify
 (GitHub)   (Maven/  (SonarQube  (Docker    (JFrog     (Terraform   (Helm →   (Prometheus
             npm)     gate)       image)     Artifactory) + Ansible)  GKE)      + Grafana)
```

1. **Checkout** the service source from GitHub.
2. **Build** it — Maven for Java services, npm for the React apps.
3. **Scan** with SonarQube; a failed quality gate stops the run.
4. **Package** the service into a Docker image.
5. **Publish** the image and artifacts to JFrog Artifactory.
6. **Provision** or update infrastructure with Terraform, applying host config
   with Ansible where needed.
7. **Deploy** to the GKE cluster with Helm.
8. **Verify** the release and watch it through Prometheus + Grafana.

---

## 8. Observability

Prometheus scrapes metrics from the services and cluster; Grafana turns that into
live dashboards and alerts, so the team sees problems early instead of hearing
about them from customers.

