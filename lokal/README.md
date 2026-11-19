# Layanan lokal

PostgreSQL 16, Redis 7, dan Garage 2.5 (penyimpanan foto yang kompatibel dengan S3) untuk menjalankan Medusa
di komputer pengembang. Butuh Docker Desktop. Nilai rahasia lokal ada di `.env` (tidak masuk git).

```
cd ~/Documents/ruanglega/ruang-lega-infra/lokal
docker compose up -d        # menyalakan semua layanan
docker compose ps           # postgres dan redis harus "healthy", garage "running"
docker compose down         # mematikan; data tetap tersimpan di volume
```

Sekali saja setelah Garage pertama kali jalan, buka bucket foto untuk dibaca publik lewat endpoint web:

```
docker compose exec garage /garage bucket website --allow localhost
```

| Layanan | Alamat dari Mac |
| --- | --- |
| PostgreSQL | `postgres://medusa:medusa-lokal@localhost:5432/ruang_lega` |
| Redis | `redis://localhost:6379` |
| Garage, API S3 (unggah) | `http://localhost:3900`, region `garage`, bucket `localhost` |
| Garage, web (foto publik) | `http://localhost:3902/<nama-file>` |

Endpoint web Garage menyajikan bucket yang namanya sama dengan Host permintaan, jadi bucket lokal bernama
`localhost`. Di produksi bucket-nya `media.ruanglega.com` di belakang nginx.

Semua nilai di sini hanya untuk komputer ini. Produksi memakai rahasia lain yang disimpan di VPS (Phase 10).
