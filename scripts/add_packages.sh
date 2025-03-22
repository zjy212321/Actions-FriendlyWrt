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

# Install openclash
(cd friendlywrt && {
    echo "src-git argon https://github.com/jerrykuku/luci-theme-argon.git" >> feeds.conf.default    
    ./scripts/feeds update argon
    ./scripts/feeds install -a argon
})
THEME_CFG="friendlywrt/package/base-files/files/etc/uci-defaults/99_THEME"
cat > ${THEME_CFG} <<EOF
#!/bin/sh
uci set luci.main.mediaurlbase="/luci-static/argon"
uci commit luci
EOF
