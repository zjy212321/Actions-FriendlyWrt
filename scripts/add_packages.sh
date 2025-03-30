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
# Install luci-theme-argon and set theme
mv ../scripts/openclash-config/luci-theme-argon_2.3.2-r20250207_all.ipk friendlywrt/package/base-files/files/etc/luci-theme-argon_2.3.2-r20250207_all.ipk
THEME_CFG="friendlywrt/package/base-files/files/etc/uci-defaults/99_THEME"
cat > ${THEME_CFG} <<EOF
#!/bin/sh
opkg install /etc/luci-theme-argon*.ipk
EOF