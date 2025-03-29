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
# ( cd friendlywrt/package && {
# mkdir -p base-files/files/etc/openclash/core
# CLASH_DEV_URL="https://github.com/vernesong/OpenClash/raw/3698b9f642b39800dc492dc6c50c76b12a085a17/master/dev/clash-linux-arm64.tar.gz"
# CLASH_TUN_URL="https://github.com/vernesong/OpenClash/raw/3698b9f642b39800dc492dc6c50c76b12a085a17/master/premium/clash-linux-arm64-2023.08.17-13-gdcc8d87.gz"
# CLASH_META_URL="https://github.com/vernesong/OpenClash/raw/3698b9f642b39800dc492dc6c50c76b12a085a17/master/meta/clash-linux-arm64.tar.gz"
# wget -qO- $CLASH_DEV_URL | tar xOvz > base-files/files/etc/openclash/core/clash
# wget -qO- $CLASH_TUN_URL | gunzip -c > base-files/files/etc/openclash/core/clash_tun
# wget -qO- $CLASH_META_URL | tar xOvz > base-files/files/etc/openclash/core/clash_meta
# chmod +x base-files/files/etc/openclash/core/clash*
# })
mv ../scripts/openclash-config/clash friendlywrt/package/base-files/files/etc/clash_tmp
mv ../scripts/openclash-config/clash_tun friendlywrt/package/base-files/files/etc/clash_tun_tmp
mv ../scripts/openclash-config/clash_meta friendlywrt/package/base-files/files/etc/clash_meta_tmp



# Set default openclash config
mv ../scripts/openclash-config/openclash friendlywrt/package/base-files/files/etc/openclash.config
mv ../scripts/openclash-config/config.yaml friendlywrt/package/base-files/files/etc/openclash.config.yaml
# mv ../scripts/openclash-config/check_start_theme_openclash.sh friendlywrt/package/base-files/files/etc/check_start_theme_openclash.sh
# Set reset button config
mv ../scripts/openclash-config/reset_pressed friendlywrt/package/base-files/files/etc/reset_pressed
mv ../scripts/openclash-config/reset_released friendlywrt/package/base-files/files/etc/reset_released
mv ../scripts/openclash-config/example.conf friendlywrt/package/base-files/files/etc/example.conf


OPENCLASH_CFG="friendlywrt/package/base-files/files/etc/uci-defaults/99_openclash"
cat > ${OPENCLASH_CFG} <<EOF
#!/bin/sh
mv -f /etc/reset_pressed /etc/rc.button/reset_pressed
mv -f /etc/reset_released /etc/rc.button/reset_released
mv -f /etc/example.conf /etc/triggerhappy/triggers.d/example.conf
chmod +x /etc/rc.button/reset_pressed
chmod +x /etc/rc.button/reset_released
chmod +x /etc/triggerhappy/triggers.d/example.conf

mv -f /etc/clash_tmp /etc/openclash/core/clash
mv -f /etc/clash_tun_tmp /etc/openclash/core/clash_tun
mv -f /etc/clash_meta_tmp /etc/openclash/core/clash_meta
mv -f /etc/openclash.config /etc/config/openclash
mv -f /etc/openclash.config.yaml /etc/openclash/config/config.yaml

sed -i 's/function init_button()/function init_start_openclash(){\n    \/etc\/init.d\/openclash stop\n    uci set openclash.config.enable=1\n    uci set openclash.config.config_path="\/etc\/openclash\/config\/config.yaml"\n    uci commit openclash\n    \/etc\/init.d\/openclash start\n}\n\nfunction init_button()/g' /root/setup.sh
sed -i 's/	init_button/	init_button\n	init_start_openclash/' /root/setup.sh
rm -rf /etc/uci-defaults/99_openclash

# chmod +x /etc/check_start_theme_openclash.sh
# ln -s /etc/check_start_theme_openclash.sh /etc/rc.d/S99check_openclash
EOF
