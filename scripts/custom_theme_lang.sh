#!/bin/bash
echo ">>> Setting theme and language..."
# 设置argon主题
sed -i '/CONFIG_PACKAGE_luci-theme-bootstrap=y/d' .config
echo "CONFIG_PACKAGE_luci-theme-argon=y" >> .config

# 设置默认语言为英文
LUCI_CFG="package/base-files/files/etc/config/luci"
sed -i "s/option lang 'auto'/option lang 'en'/" ${LUCI_CFG}

# # 添加中文语言包（可选）
# echo "CONFIG_PACKAGE_luci-i18n-base-zh-cn=y" >> .config