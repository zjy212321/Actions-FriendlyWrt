#!/bin/bash
echo ">>> Setting default WiFi..."
mkdir -p friendlywrt/package/base-files/files/etc/config
WIRELESS_CFG="friendlywrt/package/base-files/files/etc/config/wireless"

cat > ${WIRELESS_CFG} <<EOF
config wifi-device 'radio0'
    option type 'mac80211'
    option channel '161'
    option path 'platform/ff5f0000.dwmmc/mmc_host/mmc1:0001/mmc1:0001:1'
    option htmode 'VHT80'
    option country 'US'
    option cell_density '0'

config wifi-iface 'default_radio0'
    option device 'radio0'
    option network 'lan'
    option mode 'ap'
    option ssid 'UrekaGo-5G'
    option encryption 'psk2'
    option key 'password'
EOF