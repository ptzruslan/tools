#!/bin/bash

# Цвета
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
NC='\e[0m' # Сброс цвета

# Проверка пользователя
USER_CHECK="$1"
if id "$USER_CHECK" &>/dev/null; then
    echo -e "${GREEN}✅ Пользователь $USER_CHECK существует${NC}"
else
    echo -e "${RED}❌ Пользователь $USER_CHECK не найден${NC}"
fi

# Проверка, состоит ли пользователь в группе sudo
if groups "$USER_CHECK" | grep -q "sudo"; then
    echo -e "${GREEN}✅ Пользователь $USER_CHECK входит в группу sudo${NC}"
else
    echo -e "${RED}❌ Пользователь $USER_CHECK НЕ входит в группу sudo${NC}"
fi

# Проверка обновлений
UPDATES=$(apt list --upgradable 2>/dev/null | wc -l)
if [ "$UPDATES" -le 1 ]; then
    echo -e "${GREEN}✅ Все пакеты обновлены${NC}"
else
    echo -e "${RED}❌ Доступны обновления: $((UPDATES-1)) пакетов${NC}"
fi

# Проверка установленных пакетов
REQUIRED_PKGS=(mc btop nano screen git make build-essential jq lz4)
for PKG in "${REQUIRED_PKGS[@]}"; do
    if dpkg -l | grep -qw "$PKG"; then
        echo -e "${GREEN}✅ $PKG установлен${NC}"
    else
        echo -e "${RED}❌ $PKG НЕ установлен${NC}"
    fi
done

# Проверка PermitRootLogin в sshd_config
if grep -q "^PermitRootLogin no" /etc/ssh/sshd_config; then
    echo -e "${GREEN}✅ Вход под root отключен${NC}"
else
    echo -e "${RED}❌ Вход под root НЕ отключен${NC}"
fi

# Проверка работы SSH
if systemctl is-active --quiet ssh; then
    echo -e "${GREEN}✅ SSH работает${NC}"
else
    echo -e "${RED}❌ SSH НЕ работает${NC}"
fi

# Проверяем последние записи входа текущего пользователя
last_auth=$(sudo grep "$(whoami)" /var/log/auth.log | grep "Accepted" | tail -n 1)

if echo "$last_auth" | grep -q "Accepted publickey"; then
    echo -e "${GREEN}✅ Подключение по SSH-ключу успешно${NC}"
else
    echo -e "${RED}❌ Последний вход не был выполнен с помощью SSH-ключа${NC}"
    echo -e "${RED}ℹ️ Последняя запись: ${last_auth}${NC}"
fi

# Проверка установки Go и объявленных переменных среды
if [ -d "/usr/local/go" ]; then
    echo -e "${GREEN}✅ Директория Go найдена в /usr/local/go${NC}"
    if command -v go &>/dev/null; then
        GO_VERSION=$(go version)
        if [[ "$GOROOT" == "/usr/local/go" && "$GOPATH" == "$HOME/go" && "$GO111MODULE" == "on" && "$PATH" == *"/usr/local/go/bin"* && "$PATH" == *"$HOME/go/bin"* ]]; then
            echo -e "${GREEN}✅ Go установлен ($GO_VERSION) и переменные среды объявлены корректно${NC}"
        else
            echo -e "${YELLOW}⚠️ Go установлен ($GO_VERSION), но переменные среды объявлены неправильно. Проверьте настройки среды (например в ~/.profile)${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️ Go установлен, но не объявлены переменные среды. Добавьте их (например в ~/.profile)${NC}"
    fi
else
    echo -e "${RED}❌ Go НЕ установлен (директория /usr/local/go отсутствует)${NC}"
fi

exit 0
