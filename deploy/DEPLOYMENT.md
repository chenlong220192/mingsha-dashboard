# 部署指南

本文档介绍导航网站的不同部署方式。

## 📁 目录结构说明

项目已按职责重新组织，结构清晰：

```
mingsha-dashboard/
├── deploy/       # 部署相关文件
│   ├── bin/      # 部署脚本
│   ├── config/   # 配置文件（nginx.conf等）
│   ├── docker/   # Docker配置（Dockerfile）
│   ├── k8s/      # Kubernetes配置（YAML文件）
```

## 🚀 部署方式

### 1. 本地开发
```bash
# 直接在浏览器中打开
open index.html
```

### 2. Docker部署
```bash
# 构建镜像
docker build -t mingsha-dashboard:latest deploy/docker/

# 运行容器
docker run -d -p 80:80 mingsha-dashboard:latest

# 访问 http://localhost
```

### 3. 传统nginx部署
```bash
# 使用脚本部署到nginx服务器
./deploy/deploy.sh /var/www/html
```

### 4. Kubernetes部署
```bash
# 使用自动化脚本（如果本地已有镜像会跳过构建）
./deploy/k8s-deploy.sh mingsha.site:5555/app

# 强制重新构建镜像
./deploy/k8s-deploy.sh mingsha.site:5555/app --force-rebuild

# 或手动部署
kubectl apply -f deploy/k8s/
```

## 🔧 配置修改

### 修改网站内容
- 编辑 `assets/` 目录下的文件
- 重新构建Docker镜像或重新部署

### 修改nginx配置
- 编辑 `deploy/config/nginx.conf`
- 重新构建Docker镜像

### 修改K8s配置
- 编辑 `deploy/k8s/` 目录下的YAML文件
- 重新应用配置

## 📋 文件职责

| 目录 | 职责 | 主要文件 |
|------|------|----------|
| `deploy/bin/` | 脚本文件 | *.sh |
| `deploy/config/` | 配置文件 | nginx.conf |
| `deploy/docker/` | 容器化配置 | Dockerfile |
| `deploy/k8s/` | 云原生部署 | 各种YAML配置文件 |
| `deploy/` | 自动化部署 | deploy.sh, k8s-deploy.sh |

## ✅ 优势

1. **职责分离**: 每个目录都有明确的职责
2. **易于维护**: 相关文件集中管理
3. **部署灵活**: 支持多种部署方式
4. **文档完整**: 详细的使用说明
5. **自动化**: 提供便捷的部署脚本

## 🎯 推荐使用

- **开发测试**: 本地开发方式
- **单机部署**: Docker方式
- **生产环境**: Kubernetes方式 