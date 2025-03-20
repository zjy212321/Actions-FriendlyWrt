#!/bin/bash
echo ">>> Setting up OpenClash..."
# 添加OpenClash feed
echo "src-git openclash https://github.com/vernesong/OpenClash.git" >> feeds.conf.default

# 更新并安装
./scripts/feeds update openclash
./scripts/feeds install -a -p openclash

# 启用配置
echo "CONFIG_PACKAGE_luci-app-openclash=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-openclash-en=y" >> .config

# 创建配置文件目录
CLASH_DIR="package/openclash/files/etc/openclash"
mkdir -p ${CLASH_DIR}/config

# 添加默认配置文件
cat > ${CLASH_DIR}/config/config.yaml <<EOF
# OpenClash 默认配置
mixed-port: 7890
redir-port: 7892
tproxy-port: 7893
mode: Rule
log-level: info
EOF

# 设置开机自启
CLASH_INIT="package/openclash/files/etc/init.d/openclash"
sed -i '/START=95/i\START=90' ${CLASH_INIT}
ln -sf ../init.d/openclash package/openclash/files/etc/rc.d/S90openclash 2>/dev/null