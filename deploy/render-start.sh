#!/bin/sh
# Single-container start script for Render: migrate the database, then run the
# worker and the api in the background, and finally serve the site in the
# foreground on WEB_PORT (Render forwards public traffic to that port).
set -e

echo "[render-start] migrating database"
node scripts/migrate.ts

echo "[render-start] seeding demo sources"
node scripts/seed.ts

echo "[render-start] starting worker"
node apps/worker/src/main.ts &

echo "[render-start] starting api"
node apps/api/src/main.ts &

echo "[render-start] starting web"
exec node apps/web/server.ts
