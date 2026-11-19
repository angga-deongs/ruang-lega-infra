#!/usr/bin/env sh
# Memulihkan database dari satu berkas cadangan. Menghapus isi database saat ini: jalankan hanya dengan sengaja.
# Pakai: scripts/restore.sh ruanglega-db-20261120T193000Z.sql.gz.enc
set -eu
cd "$(dirname "$0")/.."
set -a; . ./.env; set +a
name="${1:?Nama berkas cadangan wajib diisi}"
printf 'Database %s akan ditimpa dari %s. Ketik PULIHKAN untuk lanjut: ' "$POSTGRES_DB" "$name"
read -r answer
[ "$answer" = "PULIHKAN" ] || { echo "Dibatalkan."; exit 1; }

rclone copy "$BACKUP_REMOTE/db/$name" /tmp/
docker compose stop medusa-server medusa-worker
openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 -pass env:BACKUP_PASSPHRASE -in "/tmp/$name" \
  | gunzip \
  | docker compose exec -T postgres sh -c "dropdb -U $POSTGRES_USER --if-exists $POSTGRES_DB && createdb -U $POSTGRES_USER $POSTGRES_DB && psql -U $POSTGRES_USER -d $POSTGRES_DB"
rm -f "/tmp/$name"
docker compose start medusa-server medusa-worker
echo "Pemulihan selesai. Periksa Admin dan situs."
