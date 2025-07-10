# 导航网站项目

一个现代化的导航网站，支持本地、Docker、Kubernetes多种部署方式，并提供一键部署Makefile。

## 📁 项目结构

```
mingsha-dashboard/
├── assets/                # 网站资源文件
│   ├── css/              # 样式文件（如 xenon.css、bootstrap.css、nav.css 等）
│   ├── js/               # JS脚本（如 xenon-custom.js、jquery-1.11.1.min.js 等）
│   └── images/           # 图片资源（logo、banner、favicon等）
├── deploy/               # 部署相关文件
│   ├── bin/              # 部署脚本（deploy.sh、k8s-deploy.sh）
│   ├── config/           # 配置文件（nginx.conf等）
│   ├── docker/           # Dockerfile
│   └── k8s/              # Kubernetes部署YAML
│   └── DEPLOYMENT.md     # 部署指南
├── index.html            # 主页面
├── 404.html              # 404页面
├── Makefile              # 一键部署入口
├── README.md             # 项目主文档（本文件）
```

## 🚀 快速开始

### 本地开发

1. 克隆项目
2. 在浏览器中打开 `index.html`

### Docker部署

```bash
docker build -t mingsha-dashboard:latest deploy/docker/
docker run -d -p 80:80 mingsha-dashboard:latest
```

### Kubernetes部署

```bash
make k8s
# 或手动执行
bash deploy/bin/k8s-deploy.sh
# 或手动应用YAML
kubectl apply -f deploy/k8s/
```

### 传统nginx部署

```bash
make deploy
# 或手动执行
bash deploy/bin/deploy.sh
```

## 🛠️ Makefile 一键部署与卸载

本项目支持使用 Makefile 快速执行部署和卸载脚本：

```bash
make deploy         # 本地/传统nginx部署（调用 deploy/bin/deploy.sh）
make k8s            # Kubernetes部署（调用 deploy/bin/k8s-deploy.sh）
make uninstall-k8s  # 卸载Kubernetes相关资源（已加 --ignore-not-found，卸载更健壮）
make help           # 查看可用命令说明
```

- 推荐使用 `make k8s` 和 `make uninstall-k8s` 管理K8s资源。
- 需确保本地已安装 make 工具。

## 📋 目录说明

- `assets/css/`：多套样式（如 xenon.css、bootstrap.css、nav.css 等）
- `assets/js/`：多种JS脚本（如 xenon-custom.js、jquery-1.11.1.min.js 等）
- `assets/images/`：logo、banner、favicon等图片资源
- `deploy/bin/`：部署脚本（deploy.sh、k8s-deploy.sh）
- `deploy/docker/`：Dockerfile
- `deploy/k8s/`：Kubernetes YAML
- `index.html`：主页面
- `404.html`：404页面
- `Makefile`：一键部署入口

## 🔧 配置说明

- **开发环境**：现代浏览器
- **Docker**：20.10+
- **Kubernetes**：1.20+，kubectl，nginx-ingress-controller
- **端口**：HTTP 80
- **资源限制**：CPU 50m-100m，内存 64Mi-128Mi
- **副本数**：2（K8s部署）

## 📖 详细文档

- [部署指南](deploy/DEPLOYMENT.md)
- [Kubernetes部署指南](deploy/k8s/README.md)


## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License
