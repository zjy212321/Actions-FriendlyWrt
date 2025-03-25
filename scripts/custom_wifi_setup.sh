#!/bin/bash
echo ">>> Setting default WiFi..."
# mkdir -p friendlywrt/package/base-files/files/etc/config
# WIRELESS_CFG="friendlywrt/package/base-files/files/etc/config/wireless"

# cat > ${WIRELESS_CFG} <<EOF
# config wifi-device 'radio0'
#     option type 'mac80211'
#     option band '5g'
#     option channel '161'
#     option path 'platform/ff5f0000.dwmmc/mmc_host/mmc1:0001/mmc1:0001:1'
#     option htmode 'VHT80'
#     option country 'US'
#     option cell_density '0'

# config wifi-iface 'default_radio0'
#     option device 'radio0'
#     option network 'lan'
#     option mode 'ap'
#     option ssid 'UrekaGo-5G'
#     option encryption 'psk2'
#     option key 'password'
# EOF


WIRELESS_CFG="friendlywrt/package/base-files/files/etc/uci-defaults/99_wifi"
cat > ${WIRELESS_CFG} <<EOF
#!/bin/sh
# 开启WiFi
uci set wireless.@wifi-device[0].disabled='0'
# 设置WiFi为5G频段（假设无线设备支持5G频段）
uci set wireless.@wifi-device[0].htmode='VHT80'  # 根据设备支持的模式调整
uci set wireless.@wifi-device[0].channel='161'  # 自动选择信道
# 设置WiFi名称和密码
uci set wireless.@wifi-iface[0].ssid='UrekaGo-5G'
uci set wireless.@wifi-iface[0].encryption='psk2'  # 使用WPA2加密
uci set wireless.@wifi-iface[0].key='password'
# 应用配置
uci commit wireless
# 重置IP地址
uci set network.lan.ipaddr='192.168.18.1'
uci commit network
# 重启网络服务以应用更改
/etc/init.d/network reload
EOF