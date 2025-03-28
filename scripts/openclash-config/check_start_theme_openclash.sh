#!/bin/sh
# 检查当前主题
CURRENT_THEME=$(uci get luci.main.mediaurlbase | awk -F '/' '{print $NF}')
# 若当前主题不是 Argon，将其设置为 Argon
if [ "$CURRENT_THEME" != "argon" ]; then
    uci set luci.main.mediaurlbase='/luci-static/argon'
    uci commit luci
    /etc/init.d/uhttpd restart
fi
# 定义检查和启动 OpenClash 的函数
# check_and_start_openclash() {
#     while true; do
#         # 检查 OpenClash 服务状态
#         if /etc/init.d/openclash status | grep -q 'running'; then
#             echo "OpenClash is running."
#         else
#             echo "OpenClash is not running. Starting OpenClash..."
#             uci set openclash.config.enable=1
#             uci set openclash.config.config_path='/etc/openclash/config/config.yaml'
#             uci commit openclash
#             /etc/init.d/openclash start
#         fi
#         # 每隔 60 秒检查一次，可以根据需要调整间隔时间
#         sleep 10
#     done
# }
# # 调用函数
# check_and_start_openclash  