# ruang-lega-infra

| Folder      | Isi                                               | Status                                          |
| ----------- | ------------------------------------------------- | ----------------------------------------------- |
| `lokal/`    | PostgreSQL, Redis, dan Garage untuk pengembangan  | Dipakai sejak Phase 4 (lihat `lokal/README.md`) |
| `produksi/` | Docker Compose, Nginx, Garage, cadangan untuk VPS | Disiapkan di Phase 10, belum dijalankan         |

Langkah produksi ada di `ruang-lega-website/docs/12-deployment.md`. Berkas `.env` dan `produksi/garage.toml` tidak pernah di-commit.
