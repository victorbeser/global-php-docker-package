
#!/bin/sh
set -eu

PHP_VERSION="${1:?Informe a versao do PHP}"
DB_DRIVER="${2:-pgsql}"

case "$PHP_VERSION" in
  5.3)
    DISTRO=jessie
    OCI8_VERSION=2.0.12
    ;;
  7.1)
    DISTRO=stretch
    OCI8_VERSION=2.1.3
    ;;
  *)
    echo "Versao de PHP invalida: $PHP_VERSION" >&2
    exit 1
    ;;
esac

case "$DB_DRIVER" in
  none|pgsql|oracle|both)
    ;;
  *)
    echo "DB_DRIVER invalido: $DB_DRIVER" >&2
    exit 1
    ;;
esac

if [ "$DB_DRIVER" = none ]; then
  echo "Nenhum driver adicional solicitado"
  exit 0
fi

# Repositorios Debian legados
printf 'deb http://archive.debian.org/debian %s main\n' \
  "$DISTRO" > /etc/apt/sources.list

printf 'Acquire::Check-Valid-Until "false";\n' \
  > /etc/apt/apt.conf.d/99archive

if [ -d /etc/apt/sources.list.d ]; then
  find /etc/apt/sources.list.d \
    -maxdepth 1 \
    -type f \
    -name '*.list' \
    -delete
fi

apt-get update

apt_install_legacy() {
  echo "AVISO: pacotes legados sem validacao de assinatura"

  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    --allow-unauthenticated \
    --no-install-recommends \
    "$@"
}

# ==========================================
# POSTGRESQL
# ==========================================

if [ "$DB_DRIVER" = pgsql ] || [ "$DB_DRIVER" = both ]; then
  echo "=== INSTALANDO POSTGRESQL ==="

  apt_install_legacy libpq-dev

  if [ "$PHP_VERSION" = "5.3" ]; then
    # Helper antigo nao aceita -j
    docker-php-ext-install pgsql pdo_pgsql
  else
    docker-php-ext-install -j"$(nproc)" pgsql pdo_pgsql
  fi
fi

# ==========================================
# ORACLE
# ==========================================

if [ "$DB_DRIVER" = oracle ] || [ "$DB_DRIVER" = both ]; then
  echo "=== INSTALANDO ORACLE ==="

  BASIC=/tmp/oracle/instantclient-basic-linux.x64-12.1.0.2.0.zip
  SDK=/tmp/oracle/instantclient-sdk-linux.x64-12.1.0.2.0.zip

  if [ ! -f "$BASIC" ] || [ ! -f "$SDK" ]; then
    echo "ERRO: Instant Client Basic/SDK nao encontrado" >&2
    exit 1
  fi

  apt_install_legacy unzip libaio1

  mkdir -p /opt/oracle

  unzip -oq "$BASIC" -d /opt/oracle
  unzip -oq "$SDK" -d /opt/oracle

  if [ ! -e /opt/oracle/instantclient_12_1/libclntsh.so ]; then
    ln -s libclntsh.so.12.1 \
      /opt/oracle/instantclient_12_1/libclntsh.so
  fi

  printf '%s\n' /opt/oracle/instantclient_12_1 \
    > /etc/ld.so.conf.d/oracle.conf

  ldconfig

  if ! command -v pecl >/dev/null 2>&1; then
    echo "ERRO: PECL indisponivel" >&2
    exit 1
  fi

  printf 'instantclient,/opt/oracle/instantclient_12_1\n' \
    | pecl install "oci8-$OCI8_VERSION"

  docker-php-ext-enable oci8
fi

rm -rf /var/lib/apt/lists/*

echo "Drivers instalados: $DB_DRIVER (PHP $PHP_VERSION)"
