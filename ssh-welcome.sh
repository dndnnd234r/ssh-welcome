#!/bin/bash

# SSH Welcome Script - System Info Display
# Add this to your ~/.bashrc to run on SSH login

# Colours for better visibility
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Print coloured headers
print_header() {
	echo -e "${CYAN}================================${NC}"
	echo -e "${WHITE}$1${NC}"
	echo -e "${CYAN}================================${NC}"
}

# Print key-value pairs
print_info() {
	echo -e "${PURPLE}=== ${YELLOW}$1: ${NC}$2 ${PURPLE}===${NC}"
}

# Clear screen, show welcome message
clear
echo -e "${GREEN}"
echo "██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗"
echo "██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝"
echo "██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗  "
echo "██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝  "
echo "╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗"
echo " ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝"
echo -e "${NC}"

# Basic System Info
print_header "SYSTEM INFORMATION"
	print_info "Hostname" "$(hostname)"
	print_info "Kernel" "$(uname -sr)"
	print_info "OS" "$(lsb_release -d 2>/dev/null | cut -f2)"
	print_info "Architecture" "$(uname -m)"
	print_info "Current User" "$(whoami)"
	print_info "Current Directory" "$(pwd)"
	print_info "Login Time" "$(date)"

echo ""

# Uptime Info
UPTIME=$(uptime -p 2>/dev/null)
LOAD=$(uptime | awk -F 'load average: ' '{print $2}')
print_header "UPTIME & LOAD"
	print_info "Uptime" "$UPTIME"
	print_info "Load Average" "$LOAD"

echo ""

# Memory Info
MEMORY=$(free -h | awk 'NR==2{printf "Used: %s/%s (%.2f%%)", $3,$2,$3*100/$2}')
MEMORY_AVAILABLE=$(free -h | awk 'NR==2 {print $6}')
print_header "MEMORY USAGE"
	print_info "RAM" "$MEMORY"
	print_info "Available RAM" "$MEMORY_AVAILABLE"

# Disk Usage
DISK=$(df -h / | awk 'NR==2{printf "Used: %s/%s (%s)", $3,$2,$5}')
DISK_AVAILABLE=$(df -h / | awk 'NR==2 {print $4}')
print_info "Root Disk" "$DISK"
print_info "Available Disk Space" "$DISK_AVAILABLE"

echo "" 

# Network Info
IP=$(ip route get 1 2>/dev/null | awk '{print $7}' | head -1)
EXT_IP=$(timeout 3 curl -s ifconfig.me 2>/dev/null || echo "Unable to fetch")
print_header "NETWORK INFORMATION"
	if [[ -n "SIP" ]]; then
		print_info "Local IP" "$IP"
	fi
	print_info "External IP" "$EXT_IP"

echo ""

# Process Info
PROCESSES=$(ps aux --no-headers | wc -l)
print_header "SYSTEM PROCESSES"
	print_info "Total Processes" "$PROCESSES"

# Top 5 CPU Consuming Processes
echo -e "${GREEN}================================${NC}"
echo -e "${YELLOW}Top 5 CPU Consuming Processes:${NC}"
ps aux --sort=-%cpu | head -6 | tail -5 | awk '{printf "  %-20s %s%%\n", $11, $3}'
echo -e "${GREEN}================================${NC}"

echo ""

# Recent Logins (last 5)
print_header "RECENT LOGINS"
last -n 5 | head -5 | while read line; do
	echo "  $line"
done

echo ""

echo -e "${GREEN}Happy computing!${NC}"

echo ""
