# Global PHP Docker Package

A lightweight Docker setup for running legacy PHP applications with Apache, optional database drivers, and GitLab CI/CD.

## Features

- PHP **5.3.29** or **7.1.11** with Apache
- **PostgreSQL** (`pgsql`, `pdo_pgsql`) and/or **Oracle** (`oci8`) support
- Live source-code updates through a Docker bind mount
- GitLab deployments: `staging` (homologation) and `master` (production)

## Quick Start

1. Copy `.env.example` to `.env`.
2. Set `PHP_VERSION` (`5.3` or `7.1`), `DB_DRIVER` (`pgsql`, `oracle`, `both`, or `none`), `APP_PORT`, and `APP_PATH`.
3. Place your PHP application in `www/`, or point `APP_PATH` to its directory.
4. Start the container:

```bash
docker compose up -d --build
```

By default, open **http://127.0.0.1:8080**. PHP file changes are reflected without rebuilding the image.

## Useful Commands

```bash
docker compose ps                 # Container status
docker compose logs -f app        # Application logs
docker compose exec app php -v    # PHP version
docker compose exec app php -m    # Loaded extensions
docker compose down               # Stop and remove containers
```

## GitLab CI/CD

Edit the **`variables`** section at the top of `.gitlab-ci.yml` (deployment path, PHP version, database driver, and port). A **Shell runner** with Docker Compose, rsync, and destination-directory permissions is required. The jobs use runner tags `hom` for `staging` and `prod` for `master`.

The pipeline syncs project files, generates the Docker `.env`, and runs Docker Compose. Application credentials should remain outside the repository.

## Notes

- Oracle requires the Instant Client 12.1 Basic and SDK archives in `oracle/`.
- PHP 5.3/7.1 and their base images are **end-of-life**. Use controlled environments and review the legacy package-installation security risks before deployment.
- Database servers are **not included**; this package installs client-side PHP drivers only.
