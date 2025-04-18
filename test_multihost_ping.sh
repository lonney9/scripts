#!/bin/bash

# Pings a set of hosts
# Displays results 
# Refreshes every 10 seconds or [space] to update now
# Some command syntax is macOS specific such as ping

# === Hosts to Ping ===
HOSTS=(
    "192.168.0.1"      # Local gateway (update as needed)
    # " " # ISP Gateway
    # " " # Local state edu/other host
    "9.9.9.9"           # Quad9 filtered DNS
    "www.example.com"   # Random internet host(s)
)

# === Default Config ===
DEFAULT_REFRESH=10
REFRESH_INTERVAL=$DEFAULT_REFRESH

# === Check for command-line argument ===
if [[ $# -ge 1 ]]; then
    if [[ $1 =~ ^[0-9]*\.?[0-9]+$ ]]; then
        REFRESH_INTERVAL=$1
    else
        echo "Invalid refresh interval: '$1'"
        echo "Usage: $0 [refresh_interval_in_seconds]"
        exit 1
    fi
fi


# === Function to ping hosts and show aligned output ===
function ping_hosts() {
    clear
    echo "Pinging hosts (updated every ${REFRESH_INTERVAL} seconds, press [space] to refresh now):"
    echo "----------------------------------------------------------------------"
    for host in "${HOSTS[@]}"; do
        result=$(ping -c 1 -W 1000 "$host" 2>/dev/null)
        if [[ $? -eq 0 ]]; then
            time=$(echo "$result" | grep -oE 'time=[0-9.]+ ms' | head -n 1)
            printf "%-25s : %s\n" "$host" "${time:-No time found}"
        else
            printf "%-25s : Unreachable\n" "$host"
        fi
    done
}

# === Main loop ===
while true; do
    ping_hosts

    # Wait with timeout, checking for key press
    read -r -s -t "$REFRESH_INTERVAL" -n 1 key
    if [[ "$key" == " " ]]; then
        continue  # Manual refresh on spacebar
    elif [[ "$key" == "q" ]]; then
        echo "Exiting..."
        exit 0
    fi
done
