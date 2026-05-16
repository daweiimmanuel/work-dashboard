# Deploy API ke Vercel

codex/draft-product-requirements-document-for-cove-67kodm
Dokumen ini sudah dirapikan untuk menghindari conflict antar versi PR (khususnya pada strategi deploy root-vs-api) dan menangani error umum `npm install exited with 254`.

## Kenapa error `npm install exited with 254`
Kasus paling umum: Vercel menjalankan `npm install` dari root repository, tapi root belum punya `package.json`.

Perbaikan di branch ini:
- Root `package.json` ditambahkan dengan npm workspace ke `api`.
- Root `vercel.json` ditambahkan dengan `installCommand` dan `buildCommand` eksplisit.

## Prasyarat
- Akun Vercel
- Repository terhubung ke Vercel Project
- Environment variables:
  - `JWT_SECRET` (**wajib**, tanpa ini login gagal)
  - `NODE_ENV=production`

## Opsi Deploy

### Opsi A (direkomendasikan): deploy dari root repo
Gunakan root directory default (`/`) di Vercel.
- Install Command: `npm install`
- Build Command: `npm run build`

### Opsi B: deploy dari folder `api`
Jika ingin set Root Directory = `api`, ini juga valid.
Pastikan konfigurasi build command tetap konsisten dengan `api/package.json`.

## Endpoint API
=======
## Prasyarat
- Akun Vercel
- Project terhubung ke repository ini
- Root Directory di Vercel diset ke `api`

## Environment Variables
Set di Vercel Project Settings:
- `JWT_SECRET` (**wajib**, tanpa ini endpoint login akan error)
- `NODE_ENV=production`

## Langkah Deploy
1. Import repository ke Vercel.
2. Pada pengaturan build:
   - **Root Directory**: `api`
   - **Install Command**: `npm install`
   - **Build Command**: `npm run build`
3. Pastikan `vercel.json` terbaca dari folder `api/`.
4. Deploy.

## Endpoint setelah deploy
- main
- `GET /health`
- `POST /auth/signup`
- `POST /auth/login`
- `POST /auth/otp/verify`

## Verifikasi cepat setelah deploy
```bash
curl -s https://<your-vercel-domain>/health
```

<codex/draft-product-requirements-document-for-cove-67kodm
## Catatan penting
- Storage saat ini masih in-memory, sehingga data tidak persisten antar serverless invocation.
- Sebelum production: migrasi ke PostgreSQL + Redis (OTP/session throttle + rate limiting).
=======
## Catatan
- Implementasi saat ini masih memakai in-memory store, jadi data tidak persisten antar instance/serverless invocation.
- Untuk production, migrasikan ke PostgreSQL + Redis (OTP/session throttle) dan tambahkan rate limiting per IP/email.
main
