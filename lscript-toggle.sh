#!/usr/bin/env bash

IDMSG="ID must be a number"

usage(){
	echo "Usage: $( basename $0 ) <ID>"
	echo "  $IDMSG"
}

set -uo pipefail

HOURS="${1:-24}"
SINCE="${HOURS} hours ago"
OUTDIR="/tmp/log-report-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$OUTDIR"

if [[ $EUID -ne 0 ]]; then 
	echo "Warning: run with sudo for full access (secure logs, journal)." > &2
fi

echo "=========================================="
echo " Rocky Linux Log Check Report"
echo " Window: last $HOURS hour(s)"
echo " Output: $OUTDIR"
echo "=========================================="
