#!/usr/bin/env bash
set -Eeuo pipefail

# Options
: "${APP_ENV:=prod}"                 # défaut prod si non défini
: "${LOAD_FIXTURES:=false}"          # true pour charger les fixtures
CONSOLE="php bin/console"

echo "⏳ Attente de la base de données..."
# Boucle d'attente : on interroge Doctrine (utilise DATABASE_URL de Symfony)
for i in {1..60}; do
  if $CONSOLE doctrine:query:sql "SELECT 1" >/dev/null 2>&1; then
    echo "✅ Base de données OK."
    break
  fi
  echo "… DB pas prête (tentative $i/60), on réessaie dans 2s"
  sleep 2
done

# Si après 60 tentatives c'est toujours pas bon, on stoppe
$CONSOLE doctrine:query:sql "SELECT 1" >/dev/null 2>&1 || {
  echo "❌ Impossible de joindre la base de données."
  exit 1
}

echo "🚀 Migrations (si nécessaire)…"
$CONSOLE doctrine:migrations:migrate --no-interaction --allow-no-migration

# Chargement des fixtures seulement si demandé (et jamais en prod par défaut)
if [[ "${LOAD_FIXTURES}" == "true" && "${APP_ENV}" != "prod" ]]; then
  echo "🧪 Chargement des fixtures…"
  $CONSOLE doctrine:fixtures:load --no-interaction --no-debug
else
  echo "↷ Fixtures ignorées (LOAD_FIXTURES=${LOAD_FIXTURES}, APP_ENV=${APP_ENV})"
fi

echo "🧹 Cache clear + warmup…"
$CONSOLE cache:clear --no-warmup
$CONSOLE cache:warmup --no-interaction

echo "✅ Prêt. Démarrage d’Apache au premier plan."
exec apache2-foreground
