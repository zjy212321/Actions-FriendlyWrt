#!/bin/bash
echo ">>> Setting default WiFi..."
WIRELESS_CFG="package/base-files/files/etc/config/wireless"

cat > ${WIRELESS_CFG} <<EOF
config wifi-device 'radio0'
    option type 'mac80211'
    option channel '11'
    option hwmode '11g'
    option path 'platform/ff160000.wifi'
    option htmode 'HT20'
    option disabled '0'

config wifi-iface 'default_radio0'
    option device 'radio0'
    option network 'lan'
    option mode 'ap'
    option ssid 'FriendlyWrt'
    option encryption 'psk2'
    option key 'yourpassword'
EOF