---
name: orbstack-deploy
description: >-
  Deploy, containerize, and run long-term background services on macOS using OrbStack and Docker.
  Use when the user wants to containerize a web application (Next.js, Node.js, Python FastAPI/Flask, Go, etc.),
  set up background daemon services with automatic restart, configure *.orb.local domains, resolve local port conflicts,
  or manage long-term local deployments on Mac.
---

# OrbStack macOS 本地常驻服务部署规范

本技能用于在 macOS 环境下，利用 **OrbStack**（极轻量 Docker/Linux 引擎）将各类 Web 与后台服务配置为**长期稳定常驻、开机自启、低资源消耗**的容器化服务。

---

## 触发场景（When to Use）

符合以下任一场景时，应当激活本技能：
1. 用户希望将当前项目“长期在 Mac 本地部署启动 / 后台常驻”。
2. 用户提到使用 **OrbStack** 或 Docker 进行本地容器化与服务托管。
3. 需要配置开机自启、崩溃重启、局域网访问（`*.orb.local`）与图形化运维。
4. 容器化部署后出现本地端口占用冲突、环境变量内联丢失、或者连接失败等问题。

---

## 核心工作流与标准流程（SOP）

### 第一步：检测并准备 OrbStack 环境

1. **检查安装与 CLI 工具**：
   ```bash
   which orbctl || which docker || brew list --cask orbstack
   ```
   * 若未安装：使用 `brew install --cask orbstack` 安装。
   * 若 `docker` 命令未链接：确认 `~/.orbstack/bin` 或软链接至 `/opt/homebrew/bin/docker` 与 `docker-compose`。

2. **检测并拉起引擎状态**：
   ```bash
   orbctl status
   ```
   * 若为 `Stopped`，执行 `orbctl start` 静默拉起；若是首次安装，使用 `open -a OrbStack` 唤起完成初始化引导。

---

### 第二步：技术栈识别与轻量容器化配置

根据当前项目的技术栈，生成对应规范的 `Dockerfile`、`.dockerignore` 与 `docker-compose.yml`。

#### 1. Next.js 项目（⚠️ 高频陷阱区域）

* **开启 Standalone 输出**：
  在 `next.config.js` 或 `next.config.ts` 中设置：
  ```ts
  const nextConfig = {
    output: "standalone",
    // ...
  };
  ```
* **⚠️ 核心避坑：防止 `NEXT_PUBLIC_*` 构建期静态写死**
  * **陷阱表现**：Next.js 在执行 `npm run build` 时，会把代码中出现的 `process.env.NEXT_PUBLIC_*` 进行 AST 静态替换为字面量。若在构建期给了假占位符（如 `placeholder.supabase.co`），打包后的服务端代码会被永远写死，容器运行时读取真实环境变量也无法覆盖，导致 `TypeError: fetch failed` 500 报错。
  * **解决方案**：
    1. **服务端动态寻址**：在 Node/服务端连接数据库或外部服务时，优先使用非 `NEXT_PUBLIC_` 变量（如 `SUPABASE_URL`）或动态索引 `process.env["NEXT_PUBLIC_..."]`。
    2. **客户端连接 Proxy 懒加载**：将客户端实例包装为代理单例（Proxy），在构建期不实例化，在运行时首个请求进入时动态读取环境变量。
    3. **构建期不要写死 ARG 占位符**。
* **多阶段构建 Dockerfile**：
  * Stage 1 (`deps`): Alpine + `npm ci`
  * Stage 2 (`builder`): `npm run build`
  * Stage 3 (`runner`): 拷贝 `.next/standalone` 和 `.next/static`，使用非 root 用户 `nextjs` 运行 `node server.js`。

#### 2. 通用 Node.js (Express / NestJS) 项目
* 使用 `node:20-alpine`，仅安装生产依赖 `npm ci --omit=dev`。
* 明确暴露监听端口并配置 `PORT`。

#### 3. Python (FastAPI / Flask) 项目
* 使用 `python:3.12-slim`，使用多阶段构建或清理 pip 缓存减少镜像体积。
* 生产级启动器使用 `uvicorn main:app --host 0.0.0.0 --port 8000`。

---

### 第三步：安全与保活编排（`docker-compose.yml`）

生成规范的 `docker-compose.yml`：
```yaml
name: <project-name>

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: <project-name>-app
    restart: unless-stopped          # 系统重启或崩溃自动拉起
    ports:
      - "3000:3000"
    env_file:
      - path: .env.local             # 敏感配置仅在运行时注入，不入镜像层
        required: false
    environment:
      - NODE_ENV=production
      - PORT=3000
      - HOSTNAME=0.0.0.0
```

* **`.dockerignore` 强制排除项**：
  必须确保排除 `node_modules`、`.next`、`.git`、`.env.local`、`*.pem`，防止本地缓存污染构建或密钥泄漏。

---

### 第四步：宿主机端口冲突排查

在启动前，**必须**检查 macOS 宿主机是否已有本地遗留进程（如之前在终端里跑的开发服务器）：
```bash
lsof -i :<PORT>
```
* **注意 IPv4 vs IPv6 陷阱**：macOS 上本地进程常监听 IPv6 `*:3000`，而 Docker 转发监听 IPv4 `0.0.0.0:3000`。如果在浏览器直接访问 `localhost`，系统会优先连入本地残留的 IPv6 进程，导致调试极其隐蔽。
* 若存在冲突进程，需通知用户或清理冲突 PID。

---

### 第五步：标准运维脚本与文档交付

1. **生成 `scripts/deploy.sh`**：
   支持 `start`、`stop`、`restart`、`logs`、`rebuild`、`status` 六大标准操作。在执行 `start` 时自动检测并拉起 `orbctl`。
2. **扩展项目快捷命令**：
   在 `package.json`（或 `Makefile`）中注入快捷别名（如 `npm run docker:up`、`docker:logs`）。
3. **补充 README 部署章节**：
   详细记录 OrbStack 图形界面查看实时日志、监控 CPU/内存与一键控制的使用指南。

---

### 第六步：双向健康验证

执行部署后，必须通过以下两项验证服务连通性：
1. **本地端口访问**：`curl -I http://localhost:<PORT>` 校验 HTTP 200。
2. **OrbStack 专属域名验证**：
   OrbStack 会自动为容器/项目分配内网域名：
   * `http://<service-name>.orb.local:<PORT>` 或 `https://<service-name>.orb.local`
   * 测试该域名是否可正常访问，若为 API 服务需确认能正常读写数据库。
