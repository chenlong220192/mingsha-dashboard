#!/bin/bash

# Kubernetes部署脚本
# 使用方法: ./k8s-deploy.sh [镜像仓库地址] [--force-rebuild]

set -e

# 获取脚本所在目录
SCRIPT_DIR=$(cd $(dirname "$0") && pwd)
PROJECT_ROOT="$SCRIPT_DIR/../.."

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 默认镜像仓库
DEFAULT_REGISTRY="mingsha.site:5555/app"
REGISTRY=${1:-$DEFAULT_REGISTRY}
IMAGE_NAME="mingsha-dashboard"
IMAGE_TAG="1.0.0"
FULL_IMAGE_NAME="$REGISTRY/$IMAGE_NAME:$IMAGE_TAG"

# 检查是否强制重新构建
FORCE_REBUILD=false
if [ "$2" = "--force-rebuild" ]; then
    FORCE_REBUILD=true
fi

echo -e "${GREEN}🚀 开始Kubernetes部署...${NC}"

# 检查必要文件
if [ ! -f "$PROJECT_ROOT/deploy/docker/Dockerfile" ] || [ ! -f "$PROJECT_ROOT/index.html" ]; then
    echo -e "${RED}❌ 错误：缺少必要文件${NC}"
    exit 1
fi

# 检查kubectl是否可用
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}❌ 错误：kubectl未安装或不在PATH中${NC}"
    exit 1
fi

# 检查kubectl连接
if ! kubectl cluster-info &> /dev/null; then
    echo -e "${RED}❌ 错误：无法连接到Kubernetes集群${NC}"
    exit 1
fi

# 检查本地是否已有镜像
# 现在无论如何都强制重新构建镜像
    echo -e "${BLUE}📦 构建Docker镜像...${NC}"
    docker build -t $FULL_IMAGE_NAME -f "$PROJECT_ROOT/deploy/docker/Dockerfile" "$PROJECT_ROOT"

#echo -e "${BLUE}📤 推送镜像到仓库...${NC}"
#docker push $FULL_IMAGE_NAME

echo -e "${BLUE}🔧 创建命名空间...${NC}"
kubectl apply -f "$PROJECT_ROOT/deploy/k8s/k8s-namespace.yaml"

echo -e "${BLUE}⚙️  创建ConfigMap...${NC}"
kubectl apply -f "$PROJECT_ROOT/deploy/k8s/k8s-configmap.yaml"

echo -e "${BLUE}🚀 部署应用...${NC}"
# 替换镜像名称
sed "s|mingsha-dashboard:latest|$FULL_IMAGE_NAME|g" "$PROJECT_ROOT/deploy/k8s/k8s-deployment-with-configmap.yaml" | kubectl apply -f -

echo -e "${BLUE}🌐 部署Ingress...${NC}"
kubectl apply -f "$PROJECT_ROOT/deploy/k8s/k8s-ingress.yaml"

echo -e "${YELLOW}⏳ 等待部署完成...${NC}"
kubectl wait --for=condition=available --timeout=300s deployment/mingsha-dashboard -n mingsha-dashboard

echo -e "${GREEN}✅ 部署完成！${NC}"

# 显示部署状态
echo -e "${BLUE}📊 部署状态:${NC}"
kubectl get pods -n mingsha-dashboard
kubectl get services -n mingsha-dashboard
kubectl get ingress -n mingsha-dashboard

echo -e "${YELLOW}📝 注意事项:${NC}"
echo "1. 请确保您的K8s集群已安装nginx-ingress-controller"
echo "2. 访问地址: http://mingsha-dashboard.internal.local"
echo "3. 如需本地测试，请将域名添加到hosts文件"
echo "4. 当前配置为HTTP模式，适合demo环境"
echo "5. 如需强制重新构建镜像，请使用: ./k8s-deploy.sh [仓库地址] --force-rebuild"

echo -e "${GREEN}🎉 Kubernetes部署脚本执行完毕！${NC}"
