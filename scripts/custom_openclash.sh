#!/bin/bash
echo ">>> Setting up OpenClash..."

# Install openclash
(cd friendlywrt && {
    echo "src-git openclash https://github.com/vernesong/OpenClash.git" >> feeds.conf.default
    ./scripts/feeds update openclash
    ./scripts/feeds install -a -p openclash
})
cat >> configs/rockchip/01-nanopi <<EOL
CONFIG_PACKAGE_luci-app-openclash=y
CONFIG_PACKAGE_luci-compat=y
EOL


# Install openclash core
( cd friendlywrt/package && {
mkdir -p base-files/files/etc/openclash/core
CLASH_DEV_URL="https://raw.githubusercontent.com/vernesong/OpenClash/master/core-lateset/dev/clash-linux-armv8.tar.gz"
CLASH_TUN_URL=$(curl -fsSL https://api.github.com/repos/vernesong/OpenClash/contents/core-lateset/premium | grep download_url | grep armv8 | awk -F '"' '{print $4}')
CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/master/core-lateset/meta/clash-linux-armv8.tar.gz"
wget -qO- $CLASH_DEV_URL | tar xOvz > base-files/files/etc/openclash/core/clash
wget -qO- $CLASH_TUN_URL | gunzip -c > base-files/files/etc/openclash/core/clash_tun
wget -qO- $CLASH_META_URL | tar xOvz > base-files/files/etc/openclash/core/clash_meta
chmod +x base-files/files/etc/openclash/core/clash*
})

# Set default openclash config
mv ../scripts/openclash-config/openclash friendlywrt/package/base-files/files/etc/openclash.config
mv ../scripts/openclash-config/config.yaml friendlywrt/package/base-files/files/etc/openclash.config.yaml
OPENCLASH_CFG="friendlywrt/package/base-files/files/etc/uci-defaults/99_openclash"
cat > ${OPENCLASH_CFG} <<EOF
mv -f /etc/openclash.config /etc/config/openclash
mv -f /etc/openclash.config.yaml /etc/openclash/config/config.yaml
/etc/init.d/openclash restart
EOF
