#!/bin/bash

# 导航网站部署脚本
# 使用方法: ./deploy.sh [nginx安装路径]

set -e

# 获取脚本所在目录
SCRIPT_DIR=$(cd $(dirname "$0") && pwd)
PROJECT_ROOT="$SCRIPT_DIR/../.."

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 默认nginx网站路径
DEFAULT_NGINX_PATH="/var/www/html"
NGINX_PATH=${1:-$DEFAULT_NGINX_PATH}

echo -e "${GREEN}🚀 开始部署导航网站...${NC}"

# 检查网站文件
if [ ! -f "$PROJECT_ROOT/index.html" ] || [ ! -f "$PROJECT_ROOT/assets/css/styles.css" ] || [ ! -f "$PROJECT_ROOT/assets/js/script.js" ]; then
    echo -e "${RED}❌ 错误：未找到 index.html 或样式/脚本文件，请确保项目结构完整${NC}"
    exit 1
fi

# 检查nginx路径是否存在
if [ ! -d "$NGINX_PATH" ]; then
    echo -e "${YELLOW}⚠️  警告：nginx路径 $NGINX_PATH 不存在${NC}"
    echo -e "${YELLOW}请确保nginx已正确安装，或指定正确的路径${NC}"
    echo -e "${YELLOW}使用方法: ./deploy.sh /path/to/nginx/html${NC}"
    exit 1
fi

# 创建备份
BACKUP_DIR="$NGINX_PATH/mingsha-dashboard-backup-$(date +%Y%m%d-%H%M%S)"
if [ -d "$NGINX_PATH/mingsha-dashboard" ]; then
    echo -e "${YELLOW}📦 创建备份...${NC}"
    sudo cp -r "$NGINX_PATH/mingsha-dashboard" "$BACKUP_DIR"
    echo -e "${GREEN}✅ 备份已创建: $BACKUP_DIR${NC}"
fi

# 复制文件
echo -e "${YELLOW}📁 复制文件到nginx目录...${NC}"
sudo mkdir -p "$NGINX_PATH/mingsha-dashboard/assets/css"
sudo mkdir -p "$NGINX_PATH/mingsha-dashboard/assets/js"
sudo cp "$PROJECT_ROOT/index.html" "$NGINX_PATH/mingsha-dashboard/"
sudo cp "$PROJECT_ROOT/assets/css/styles.css" "$NGINX_PATH/mingsha-dashboard/assets/css/"
sudo cp "$PROJECT_ROOT/assets/js/script.js" "$NGINX_PATH/mingsha-dashboard/assets/js/"
[ -f "$PROJECT_ROOT/README.md" ] && sudo cp "$PROJECT_ROOT/README.md" "$NGINX_PATH/mingsha-dashboard/"

# 设置权限
echo -e "${YELLOW}🔐 设置文件权限...${NC}"
sudo chown -R www-data:www-data "$NGINX_PATH/mingsha-dashboard"
sudo chmod -R 755 "$NGINX_PATH/mingsha-dashboard"

# 检查nginx配置
echo -e "${YELLOW}🔧 检查nginx配置...${NC}"
if [ -f "$PROJECT_ROOT/deploy/config/nginx.conf" ]; then
    echo -e "${YELLOW}📋 发现nginx配置文件，请手动添加到nginx配置中${NC}"
    echo -e "${YELLOW}配置文件位置: $PROJECT_ROOT/deploy/config/nginx.conf${NC}"
fi

# 重启nginx（如果可能）
if command -v systemctl &> /dev/null; then
    echo -e "${YELLOW}🔄 重启nginx服务...${NC}"
    sudo systemctl reload nginx || sudo systemctl restart nginx
elif command -v service &> /dev/null; then
    echo -e "${YELLOW}🔄 重启nginx服务...${NC}"
    sudo service nginx reload || sudo service nginx restart
else
    echo -e "${YELLOW}⚠️  无法自动重启nginx，请手动重启${NC}"
fi

echo -e "${GREEN}✅ 部署完成！${NC}"
echo -e "${GREEN}🌐 网站地址: http://your-domain.com/mingsha-dashboard/${NC}"
echo -e "${GREEN}📁 文件位置: $NGINX_PATH/mingsha-dashboard/${NC}"

# 显示nginx配置建议
echo -e "${YELLOW}📝 nginx配置建议:${NC}"
echo "在nginx配置文件中添加以下内容："
echo ""
echo "location /mingsha-dashboard {"
echo "    alias $NGINX_PATH/mingsha-dashboard;"
echo "    index index.html;"
echo "    try_files \$uri \$uri/ /mingsha-dashboard/index.html;"
echo "}"
echo ""
echo -e "${GREEN}🎉 部署脚本执行完毕！${NC}"
