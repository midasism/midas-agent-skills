# Midas Agent Skills - 开源推广与社区收录指南 (Distribution Guide)

本文档记录了 `midas-agent-skills`（重点包括 `orbstack-deploy` 技能）的**精选提交与推广渠道清单**、**各平台专属文案模板**与 **PR 提交规范**。

---

## 🎯 第一梯队：GitHub Awesome 技能列表（提 PR 收录）

专门收录 AI Agent 实用技能的开源 Awesome 仓库。提交后由维护者合并，直接获得长期高质量的开发者流量与 Star。

### 1. [kodustech/awesome-agent-skills](https://github.com/kodustech/awesome-agent-skills)
* **目标分类**：`### DevOps` 或 `### Tooling`
* **收录格式**：表格形式（Table）
* **插入行内容**：
  ```markdown
  | [orbstack-deploy](https://github.com/midasism/midas-agent-skills/tree/main/skills/orbstack-deploy) | Containerize, daemonize, and manage local background web services (Next.js, Python, Node) on macOS using OrbStack with auto-start and port conflict protection. |
  ```

### 2. [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills)
* **目标分类**：`### Development & Code Tools`
* **收录格式**：列表形式（List）
* **插入行内容**：
  ```markdown
  - [orbstack-deploy](https://github.com/midasism/midas-agent-skills/tree/main/skills/orbstack-deploy) - Production-ready skill to containerize and daemonize local web services on macOS using OrbStack with auto-restart, *.orb.local domains, and Next.js standalone optimization. *By [@midasism](https://github.com/midasism)*
  ```

### 3. [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills)
* **目标分类**：`### Community Skills` -> `DevOps / Deployment`
* **收录格式**：折叠面板列表
* **插入行内容**：
  ```markdown
  - **[midasism/midas-agent-skills](https://github.com/midasism/midas-agent-skills)** - Production-grade Agent Skills collection, featuring `orbstack-deploy` for lightweight macOS daemon containerization with OrbStack.
  ```

---

## 🚀 提 PR 专用模板（PR Title & Description）

向 Awesome 仓库提 PR 时可直接复制以下规范：

* **PR 标题**：`Add orbstack-deploy skill to DevOps / Development tools`
* **PR 内容 (Markdown)**：
```markdown
### Summary
Add `orbstack-deploy` skill to the DevOps / Development Tools section.

### Details
- **Name**: `orbstack-deploy`
- **Repository**: [midasism/midas-agent-skills](https://github.com/midasism/midas-agent-skills/tree/main/skills/orbstack-deploy)
- **Target Category**: DevOps / Development Tools
- **What it does**: 
  A production-ready skill for macOS developers to automatically containerize and run web services (Next.js Standalone, Node.js, Python FastAPI) as persistent local background daemons with OrbStack.
- **Key Features**:
  1. Built-in Next.js build-time env inlining guard (solves `NEXT_PUBLIC_*` placeholder trap).
  2. Automatic macOS IPv4/IPv6 port conflict detection and resolution.
  3. Zero-overhead background operation with OrbStack native `*.orb.local` local domains.
  4. Generates multi-stage Dockerfile, docker-compose, and deploy management scripts.
- **Platforms**: Google Antigravity, Claude Code, Codex, and Cursor.
```

---

## 🍎 第二梯队：OrbStack 官方与垂直社区发帖

### 1. OrbStack GitHub Discussions
* **地址**：[orbstack/orbstack/discussions](https://github.com/orbstack/orbstack/discussions)（版块：**Show and tell**）
* **标题**：`[Show and Tell] Created an open-source AI Agent skill to containerize & daemonize any web project on OrbStack with zero-config`
* **正文大纲**：
  * 说明为什么开发这个技能：痛恨 Docker Desktop 占用过高，喜欢 OrbStack 的轻量与极速，因此教会 AI Agent 自动化把 Next.js/FastAPI 等本地服务托管进 OrbStack。
  * 核心亮点：自动生成多阶段 Alpine 容器、防范 Next.js 环境变量构建期写死、端口探测、自动支持 `*.orb.local` 域名。
  * 附上一键安装命令与 GitHub 链接。

### 2. Reddit (`r/OrbStack`, `r/macapps`, `r/selfhosted`)
* **标题**：`I made an AI Agent skill to auto-deploy local side-projects to OrbStack on macOS`
* **内容**：以开发者经验帖形式分享，突出内存占用仅几十 MB 的实际数据对比。

---

## 💬 第三梯队：国内优质开发者社区

### 1. V2EX (`/go/programmer` 或 `/go/macos`)
* **标题**：`分享一个开源 Agent 技能：让 AI 一句话把本地项目以 OrbStack 容器化常驻后台（开机自启/避坑踩坑记录）`
* **核心内容切入点**：
  1. **痛点**：平时写了个人项目想在 Mac 本机长期开着跑（比如面经系统、自建工具、爬虫），直接跑开发模式发热占内存，手写 Dockerfile 和 launchd 又繁琐。
  2. **解决方案**：提炼了一个跨平台的 Agent Skill `orbstack-deploy`，支持 Antigravity、Claude Code、Cursor 等。
  3. **实际踩坑点分享**：分享 Next.js `NEXT_PUBLIC_*` 在 Docker 编译期被 AST 写死的真实案例及解决思路（极具技术讨论度）。
  4. **开源地址与一键安装**：引导 GitHub Star。

### 2. 即刻 / X (Twitter)
* **标签**：`#OrbStack` `#AIAgent` `#独立开发` `#Mac效率`
* **形式**：附带终端运行截图与 OrbStack 界面截图，直观展示“一句话启动服务且自动分配 local 域名”。
