# 使用官方nginx镜像作为基础镜像
FROM nginx:1.29.0-alpine

# 复制网站文件到nginx默认目录
COPY index.html /usr/share/nginx/html/
COPY 404.html /usr/share/nginx/html/
COPY assets /usr/share/nginx/html/assets/
COPY cn /usr/share/nginx/html/cn/

# 复制nginx配置文件
COPY deploy/config/nginx.conf /etc/nginx/conf.d/default.conf

# 设置文件权限
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# 暴露80端口
EXPOSE 80

# 启动nginx
CMD ["nginx", "-g", "daemon off;"] 