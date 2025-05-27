#!/bin/bash

# Colors
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
NC='\e[0m' # Reset color

# User check
USER_CHECK="$1"
if id "$USER_CHECK" &>/dev/null; then
    echo -e "${GREEN}✅ User $USER_CHECK exists${NC}"
else
    echo -e "${RED}❌ User $USER_CHECK not found${NC}"
fi

# Check if user is in sudo group
if groups "$USER_CHECK" | grep -q "sudo"; then
    echo -e "${GREEN}✅ User $USER_CHECK is in the sudo group${NC}"
else
    echo -e "${RED}❌ User $USER_CHECK is NOT in the sudo group${NC}"
fi

# Check for available updates
UPDATES=$(apt list --upgradable 2>/dev/null | wc -l)
if [ "$UPDATES" -le 1 ]; then
    echo -e "${GREEN}✅ All packages are up to date${NC}"
else
    echo -e "${RED}❌ Updates available: $((UPDATES-1)) packages${NC}"
fi

# Check for required packages
REQUIRED_PKGS=(mc btop nano screen git make build-essential jq lz4)
for PKG in "${REQUIRED_PKGS[@]}"; do
    if dpkg -l | grep -qw "$PKG"; then
        echo -e "${GREEN}✅ $PKG is installed${NC}"
    else
        echo -e "${RED}❌ $PKG is NOT installed${NC}"
    fi
done

# Check PermitRootLogin in sshd_config
if grep -q "^PermitRootLogin no" /etc/ssh/sshd_config; then
    echo -e "${GREEN}✅ Root login is disabled${NC}"
else
    echo -e "${RED}❌ Root login is NOT disabled${NC}"
fi

# Check if SSH service is running
if systemctl is-active --quiet ssh; then
    echo -e "${GREEN}✅ SSH is running${NC}"
else
    echo -e "${RED}❌ SSH is NOT running${NC}"
fi

# Check Go installation and environment variables
if [ -d "/usr/local/go" ]; then
    echo -e "${GREEN}✅ Go directory found at /usr/local/go${NC}"
    if command -v go &>/dev/null; then
        GO_VERSION=$(go version)
        if [[ "$GOROOT" == "/usr/local/go" && "$GOPATH" == "$HOME/go" && "$GO111MODULE" == "on" && "$PATH" == *"/usr/local/go/bin"* && "$PATH" == *"$HOME/go/bin"* ]]; then
            echo -e "${GREEN}✅ Go is installed ($GO_VERSION) and environment variables are correctly set${NC}"
        else
            echo -e "${YELLOW}⚠️ Go is installed ($GO_VERSION), but environment variables are not set correctly. Check your profile settings (e.g. in ~/.profile)${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️ Go is installed, but environment variables are not set. Add them (e.g. in ~/.profile)${NC}"
    fi
else
    echo -e "${RED}❌ Go is NOT installed (directory /usr/local/go is missing)${NC}"
fi

exit 0
