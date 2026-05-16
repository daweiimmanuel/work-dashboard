# Deploy API ke Vercel

Jika masih muncul `Command "npm install" exited with 254`, penyebab umumnya adalah perbedaan dukungan npm/workspace di environment build Vercel.

## Fix yang diterapkan
Konfigurasi root diubah agar **tidak bergantung npm workspace**:
- Install dependency diarahkan langsung ke folder `api` via `npm --prefix api install`.
- Build juga dijalankan langsung dari folder `api` via `npm --prefix api run build`.

Dengan ini, Vercel tidak perlu memproses workspace root untuk install dependency API.

## Prasyarat
- Repository terhubung ke Vercel
- Env vars:
  - `JWT_SECRET` (wajib)
  - `NODE_ENV=production`

## Konfigurasi Vercel (root repo)
Gunakan root directory default (`/`).
`vercel.json` root sudah mengatur:
- `installCommand`: `npm run install:api`
- `buildCommand`: `npm run build`

## Endpoint
- `GET /health`
- `POST /auth/signup`
- `POST /auth/login`
- `POST /auth/otp/verify`

## Verifikasi
```bash
curl -s https://<your-vercel-domain>/health
```

## Catatan
- Penyimpanan masih in-memory, jadi belum production-ready untuk multi-instance/serverless.
