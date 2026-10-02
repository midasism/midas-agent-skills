# Midas Agent Skills

A curated collection of production-grade AI Agent Skills for **Google Antigravity**, **Claude Code**, **OpenAI Codex**, and other Agentic coding tools.

---

## 📦 Skills Directory

| Skill Name | Description | Platforms | Category |
| :--- | :--- | :--- | :--- |
| [**`orbstack-deploy`**](./skills/orbstack-deploy) | 在 macOS 上使用 OrbStack 将服务配置为轻量容器化后台常驻服务（开机自启、保活策略、本地域名与防坑指南）。 | macOS | DevOps / Deployment |

---

## 🚀 Quick Install / 快速安装

### 方式一：一键脚本安装（推荐）

直接在终端执行一键命令：

```bash
# 安装所有技能
curl -fsSL https://raw.githubusercontent.com/midasism/midas-agent-skills/main/install.sh | bash

# 或者仅安装指定的单个技能（如 orbstack-deploy）
curl -fsSL https://raw.githubusercontent.com/midasism/midas-agent-skills/main/install.sh | bash -s orbstack-deploy
```

### 方式二：Git Clone 全局接入

```bash
# 克隆到标准 Agent 技能目录
git clone https://github.com/midasism/midas-agent-skills.git ~/.agents/skills/midas-skills

# 如果使用 Google Antigravity，创建软链接：
ln -sf ~/.agents/skills/midas-skills/skills/* ~/.gemini/antigravity/skills/
```

安装后，Agent 即可在对话中通过自然语言自动感知并激活对应技能！

---

## 🛠️ Included Skills Detail

### [`orbstack-deploy`](./skills/orbstack-deploy)

专为 macOS 开发者打造的本地后台守护与轻量容器化部署技能。

* **适用场景**：
  * 将 Next.js、Python FastAPI、Node 等服务在 Mac 本机长期后台常驻并开机自启。
  * 自动解决 macOS 宿主机与 Docker IPv4/IPv6 端口冲突。
  * 避免 Next.js 构建期将 `NEXT_PUBLIC_*` 变量静态写死（占位符失效陷阱）。
* **内置套件**：
  * 多阶段轻量 Alpine `Dockerfile` 模板。
  * `restart: unless-stopped` 保活编排配置 `docker-compose.yml`。
  * 包含 `start/stop/restart/logs/rebuild/status` 的一键运维脚本 `scripts/deploy.sh`。

---

## 🤝 Contributing & Submitting to Awesome Lists

欢迎提交 Issue 或 PR 扩展更多实用技能。

如果你正在维护 Awesome Agent Skills 列表，欢迎收录本仓库或单独收录指定技能：

```markdown
- [orbstack-deploy](https://github.com/midasism/midas-agent-skills/tree/main/skills/orbstack-deploy) - Deploy and run background daemon services with OrbStack on macOS.
```

---

## 📄 License

[MIT](./LICENSE) © 2026 midasgao
