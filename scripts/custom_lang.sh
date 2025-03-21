#!/bin/bash
echo ">>> Setting language..."

# # 设置默认语言为英文
# mkdir -p friendlywrt/package/base-files/files/etc/config
# LUCI_CFG="friendlywrt/package/base-files/files/etc/config/luci"
# sed -i "s/option lang 'auto'/option lang 'en'/" ${LUCI_CFG}


LANG_CFG="friendlywrt/package/base-files/files/etc/uci-defaults/99_LANG"
cat > ${LANG_CFG} <<EOF
#!/bin/sh
# 设置 LuCI 的语言为英语
uci set luci.main.lang='en'
# 提交配置更改
uci commit luci
EOF
