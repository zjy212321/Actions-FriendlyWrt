#!/bin/bash
echo ">>> Setting up OpenClash..."

# Install openclash
(cd friendlywrt/package && {
git clone --depth 1 -b master --single-branch https://github.com/vernesong/OpenClash.git 
mv OpenClash/luci-app-openclash ./luci-app-openclash
rm -rf OpenClash
})

# Install openclash core
( cd friendlywrt/package && {
mkdir -p base-files/files/etc/openclash/core
CLASH_DEV_URL="https://raw.githubusercontent.com/vernesong/OpenClash/master/core-lateset/dev/clash-linux-armv8.tar.gz"
CLASH_TUN_URL=$(curl -fsSL https://api.github.com/repos/vernesong/OpenClash/contents/core-lateset/premium | grep download_url | grep $1 | awk -F '"' '{print $4}')
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
