#!/usr/bin/env bash
# Wrapper for HA-Bridge to pass in ${intensity.percent} and do some math
DISCOSPEED=$(( ($1 - 1) * 20 + 30 )) $( dirname $0 )/yeelight-scene.sh 0 Disco

set -euo pipefail

IFACE="${1:-}"
SUBNET="${2:-}"

if [[ -z "$IFACE" ]]; then
    echo "Usage: $0 <interface> [subnet]"
    echo "Example: $0 eth0 192.168.1.0/24"
    exit 1
fi

if [[ $EUID -ne 0 ]]; then
    echo "Warning: ARP scanning usually requires root. Try: sudo $0 $*" >&2
fi


#Auto-detect subnet from interface if not provided
if [[ -z "$SUBNET" ]]; then
	IP_CIDR=$(ip -o -f inet addr show "$IFACE" | awk '{print $4}')
    if [[ -z "$IP_CIDR" ]]; then
        echo "Could not detect subnet on $IFACE. Specify it manually." >&2
        exit 1
    fi
    # Convert host IP/CIDR to network address using ipcalc if present, else python fallback
    if command -v ipcalc >/dev/null 2>&1; then
        SUBNET=$(ipcalc -n "$IP_CIDR" | grep -i network | awk '{print $2}')
    else
        SUBNET=$(python3 - "$IP_CIDR" <<'EOF'
import sys, ipaddress
net = ipaddress.ip_interface(sys.argv[1]).network
print(net)
EOF
)
    fi
fi
