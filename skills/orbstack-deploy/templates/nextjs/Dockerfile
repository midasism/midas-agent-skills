# -------------------------------------------------------------
# Base Stage
# -------------------------------------------------------------
FROM node:20-alpine AS base
RUN apk add --no-cache libc6-compat

# -------------------------------------------------------------
# Dependencies Stage
# -------------------------------------------------------------
FROM base AS deps
WORKDIR /app
COPY package.json package-lock.json* yarn.lock* pnpm-lock.yaml* ./
RUN \
  if [ -f package-lock.json ]; then npm ci; \
  elif [ -f yarn.lock ]; then yarn --frozen-lockfile; \
  elif [ -f pnpm-lock.yaml ]; then corepack enable pnpm && pnpm i --frozen-lockfile; \
  else npm i; \
  fi

# -------------------------------------------------------------
# Build Stage
# -------------------------------------------------------------
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production

# ⚠️ 注意：不要在此处硬编码任何真实密钥或占位符，运行时通过 compose 动态注入
RUN npm run build

# -------------------------------------------------------------
# Runner Stage
# -------------------------------------------------------------
FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs

# 拷贝静态资源与独立包
COPY --from=builder /app/public ./public 2>/dev/null || true
RUN mkdir -p .next && chown nextjs:nodejs .next

COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs
EXPOSE 3000

CMD ["node", "server.js"]
