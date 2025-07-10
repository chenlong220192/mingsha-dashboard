# 导航网站 Makefile

.PHONY: help deploy k8s uninstall uninstall-k8s clean

help:
	@echo "可用命令："
	@echo "  make deploy         # 本地/传统nginx部署（调用deploy/bin/deploy.sh）"
	@echo "  make k8s            # Kubernetes部署（调用deploy/bin/k8s-deploy.sh）"
	@echo "  make uninstall-k8s  # 卸载Kubernetes相关资源"
	@echo "  make help           # 显示帮助"

deploy:
	bash deploy/bin/deploy.sh

k8s:
	bash deploy/bin/k8s-deploy.sh

uninstall-k8s:
	kubectl delete -f deploy/k8s/k8s-ingress.yaml --ignore-not-found
	kubectl delete -f deploy/k8s/k8s-deployment-with-configmap.yaml --ignore-not-found
	kubectl delete -f deploy/k8s/k8s-configmap.yaml --ignore-not-found
	kubectl delete -f deploy/k8s/k8s-namespace.yaml --ignore-not-found
