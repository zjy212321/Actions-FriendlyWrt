#!/bin/bash
echo ">>> Setting up OpenClash..."

# {{ Add OpenClash
(cd friendlywrt && {
    # 添加软件源
    echo "src-git openclash https://github.com/vernesong/OpenClash.git" >> feeds.conf.default
    
    # 更新并安装
    ./scripts/feeds update openclash
    ./scripts/feeds install -a -p openclash

    mkdir -p package/openclash/files/etc/openclash/config
})

# 写入编译选项
cat >> configs/rockchip/01-nanopi <<EOL
CONFIG_PACKAGE_luci-app-openclash=y
CONFIG_PACKAGE_luci-i18n-openclash-zh-cn=y
CONFIG_PACKAGE_coreutils-nohup=y
EOL

# 设置默认配置文件
CLASH_DIR="friendlywrt/package/openclash/files/etc/openclash"
cat > ${CLASH_DIR}/config/config.yaml <<EOF
# OpenClash 默认配置
mixed-port: 7890
redir-port: 7892
tproxy-port: 7893
mode: Rule
log-level: info
EOF

# 设置开机自启
(cd friendlywrt && {
    ln -sf ../init.d/openclash package/openclash/files/etc/rc.d/S90openclash 2>/dev/null
    sed -i 's/START=95/START=90/' package/openclash/files/etc/init.d/openclash
})
# }}
