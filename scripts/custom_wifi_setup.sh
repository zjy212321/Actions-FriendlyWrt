#!/bin/bash
echo ">>> Setting default WiFi..."
# mkdir -p friendlywrt/package/base-files/files/etc/config
# WIRELESS_CFG="friendlywrt/package/base-files/files/etc/config/wireless"

mv ../scripts/openclash-config/setup.sh friendlywrt/package/base-files/files/etc/setup.sh
WIRELESS_CFG="friendlywrt/package/base-files/files/etc/uci-defaults/99_wifi"
cat > ${WIRELESS_CFG} <<EOF
#!/bin/sh
mv -f /etc/setup.sh /root/setup.sh
chmod +x /root/setup.sh
EOF