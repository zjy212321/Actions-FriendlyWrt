#!/bin/bash

# {{ Add luci-app-diskman
(cd friendlywrt && {
    mkdir -p package/luci-app-diskman
    wget https://raw.githubusercontent.com/lisaac/luci-app-diskman/master/applications/luci-app-diskman/Makefile.old -O package/luci-app-diskman/Makefile
})
cat >> configs/rockchip/01-nanopi <<EOL
CONFIG_PACKAGE_luci-app-diskman=y
CONFIG_PACKAGE_luci-app-diskman_INCLUDE_btrfs_progs=y
CONFIG_PACKAGE_luci-app-diskman_INCLUDE_lsblk=y
CONFIG_PACKAGE_luci-i18n-diskman-zh-cn=y
CONFIG_PACKAGE_smartmontools=y
EOL
# }}

# {{ Add luci-theme-argon
echo ">>> Add luci-theme-argon..."

# Install luci-theme-argon
(cd friendlywrt && {
    echo 'src-git jerryk https://github.com/jerrykuku/openwrt-package' >> feeds.conf.default
    ./scripts/feeds update jerryk
    ./scripts/feeds install luci-theme-argon
})
THEME_CFG="friendlywrt/package/base-files/files/etc/uci-defaults/99_THEME"
cat > ${THEME_CFG} <<EOF
#!/bin/sh
uci set luci.main.mediaurlbase="/luci-static/argon"
uci commit luci
EOF
