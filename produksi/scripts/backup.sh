#!/usr/bin/env sh
# Cadangan harian database: pg_dump, dikompres, dienkripsi AES-256, lalu dikirim ke luar VPS lewat rclone.
# Jadwal (crontab root): 30 19 * * * /opt/ruang-lega/produksi/scripts/backup.sh  (= 02.30 WIB)
# Butuh: docker, openssl, rclone dengan remote yang dikonfigurasi pemilik (`rclone config`).
set -eu
cd "$(dirname "$0")/.."
set -a; . ./.env; set +a

: "${BACKUP_PASSPHRASE:?BACKUP_PASSPHRASE belum diisi}"
: "${BACKUP_REMOTE:?BACKUP_REMOTE belum diisi}"
stamp=$(date -u +%Y%m%dT%H%M%SZ)
file="/tmp/ruanglega-db-$stamp.sql.gz.enc"

docker compose exec -T postgres pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" --no-owner \
  | gzip -9 \
  | openssl enc -aes-256-cbc -pbkdf2 -iter 200000 -salt -pass env:BACKUP_PASSPHRASE -out "$file"

rclone copy "$file" "$BACKUP_REMOTE/db/"
rm -f "$file"
rclone delete "$BACKUP_REMOTE/db/" --min-age "${BACKUP_KEEP_DAYS:-14}d"
echo "Cadangan $stamp terkirim ke $BACKUP_REMOTE/db/"
