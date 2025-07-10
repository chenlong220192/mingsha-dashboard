# Kubernetes 配置说明

## 镜像拉取策略

### imagePullPolicy: IfNotPresent

在 Deployment 配置中设置了 `imagePullPolicy: IfNotPresent`，这意味着：

1. **优先使用本地镜像** - 如果节点上已有指定镜像，直接使用本地镜像
2. **避免网络拉取** - 减少网络传输，提高部署速度
3. **适合开发环境** - 特别适合本地开发和测试环境

### 镜像拉取策略选项

| 策略 | 说明 | 适用场景 |
|------|------|----------|
| `IfNotPresent` | 本地有镜像就用本地，没有才拉取 | 开发环境、本地测试 |
| `Always` | 总是从仓库拉取镜像 | 生产环境、确保镜像最新 |
| `Never` | 只使用本地镜像，从不拉取 | 离线环境、安全要求高的环境 |

## 配置文件说明

### k8s-namespace.yaml
- 创建专用的命名空间 `mingsha-dashboard`
- 便于资源管理和隔离

### k8s-configmap.yaml
- 管理 nginx 配置
- 支持配置热更新（重启 Pod 后生效）

### k8s-deployment-with-configmap.yaml
- 完整的部署配置
- 包含 Deployment、Service、Ingress
- 使用 ConfigMap 管理配置
- 配置了健康检查和资源限制

### k8s-ingress.yaml
- 配置外部访问
- 域名：`mingsha-dashboard.internal.local`
- 支持 CORS 和安全头

## 部署流程

1. **创建命名空间**
2. **创建 ConfigMap**
3. **部署应用**（Deployment + Service）
4. **配置 Ingress**

## 访问方式

- **内部访问**: `mingsha-dashboard-service.mingsha-dashboard.svc.cluster.local:80`
- **外部访问**: `http://mingsha-dashboard.internal.local`

## 注意事项

1. 确保本地已有镜像或镜像仓库可访问
2. 如需强制拉取最新镜像，可删除本地镜像或修改 `imagePullPolicy` 为 `Always`
3. 域名需要配置 DNS 解析或添加到 hosts 文件
