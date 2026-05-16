# Deploy API ke Vercel

## Kenapa error `npm install exited with 254`
Penyebab paling umum di setup ini: Vercel menjalankan install di root repository, sementara sebelumnya `package.json` hanya ada di folder `api/`.

Perbaikan yang sudah diterapkan:
- Menambahkan `package.json` di root (workspace ke `api`) supaya `npm install` di root sukses.
- Menambahkan `vercel.json` di root agar Vercel punya install/build command yang eksplisit.

## Prasyarat
- Akun Vercel
- Project terhubung ke repository ini
- Env var: `JWT_SECRET` (**wajib**) dan `NODE_ENV=production`

## Opsi Deploy yang direkomendasikan

### Opsi A (recommended): Deploy dari root repo
Gunakan setting default root (`/`) di Vercel.
- Install Command: `npm install`
- Build Command: `npm run build`

### Opsi B: Deploy dari folder `api`
Jika ingin set Root Directory = `api`, itu juga valid.

## Endpoint
- `GET /health`
- `POST /auth/signup`
- `POST /auth/login`
- `POST /auth/otp/verify`

## Verifikasi cepat
```bash
curl -s https://<your-vercel-domain>/health
```

## Catatan
- Storage saat ini masih in-memory (non-persistent), belum suitable untuk production multi-instance/serverless.
