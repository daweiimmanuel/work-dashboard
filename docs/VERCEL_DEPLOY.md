# Deploy API ke Vercel

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
- `GET /health`
- `POST /auth/signup`
- `POST /auth/login`
- `POST /auth/otp/verify`

## Verifikasi cepat setelah deploy
```bash
curl -s https://<your-vercel-domain>/health
```

## Catatan
- Implementasi saat ini masih memakai in-memory store, jadi data tidak persisten antar instance/serverless invocation.
- Untuk production, migrasikan ke PostgreSQL + Redis (OTP/session throttle) dan tambahkan rate limiting per IP/email.
