# Настройка и проверка сервера

> Эта инструкция поможет студентам настроить, а скрипт позволит проверить правильность настройки сервера после его аренды.
Скрипт проверяет наличие пользователя, установленных пакетов, конфигурацию SSH, а также корректность установки Go и переменных среды.

## 🔧 Что должен выполнить студент?

1. **Подключиться к серверу через SSH**:
   ```bash
   ssh <имя_пользователя>@<ip_сервера>   # Пример: root@192.168.208.11
   ```
  > ❗️ Важно: ввод пароля в консоли НЕ ОТОБРАЖАЕТСЯ ❗️
---   

2. **Создать нового пользователя и дать ему права sudo**:
   ```bash
   sudo adduser <имя_пользователя>  # Пример: sudo adduser superman
   sudo usermod -aG sudo <имя_пользователя>  # Пример: sudo usermod -aG sudo superman
   ```
---

3. **Переключиться на нового пользователя**:
   ```bash
   su <имя_пользователя> # Пример: su superman
   ```
   #### Произвести проверку подключения нового пользователя удалённо:
   - Разорвать соединение с сервером:
   ```bash
   exit # Закрыть соединение с сервером
   ```
   - Подключиться к серверу используя новое имя пользователя! Не ROOT!
   ```bash
   ssh <имя_пользователя>@<ip_сервера>   # Пример: superman@192.168.208.11
   ```
---

4. **Обновить систему и установить необходимые пакеты**:
   ```bash
   sudo apt update && sudo apt upgrade -y # Обновляем список пакетов и устанавливаем обновления
   sudo apt install mc btop nano screen git make build-essential jq lz4 -y # Устанавливаем необходимое ПО
   ```
---

5. **Генерация ключа и настройка входа**:<br>

   >❗️ Важно: эти действия производятся на вашем ПК / Ноутбуке / Mac Book, а не на сервере ❗️
   #### Генерация ключа:
   ```bash
   ssh-keygen -t ed25519  # !!! Не меняйте имя и путь сохранения ключа (просто нажмимайте клавишу Ввод)! Также можно создать пароль для ключа.
   ```
   #### Отправка ключа на сервер:
     - Windows OS: (не забудьте изменить имя и ip адрес)
    ```bash
   Get-Content "$env:USERPROFILE\.ssh\id_ed25519.pub" | ssh <имя_пользователя>@<ip_сервера> "mkdir -p ~/.ssh; cat >> ~/.ssh/authorized_keys; chmod 700 ~/.ssh; chmod 600 ~/.ssh/authorized_keys"
   ```
     - Mac OS: (не забудьте изменить имя и ip адрес)
   ```bash
   cat ~/.ssh/id_ed25519.pub | ssh <имя_пользователя>@<ip_сервера> 'mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'
   ```
   - Linux
   ```bash
   ssh-copy-id <имя_пользователя>@<ip_сервера>
   ```
   #### Проверка подключения по ключу:
      ***Открываем новое окно терминала и подкючаемся к серверу.***
   > ***Возможно понадобится ввести пароль от ключа! Тот пароль, который вы задали при генерации***
    ```bash
   ssh <имя_пользователя>@<ip_сервера>
   ```
---

6. **Отключить вход для root по SSH**:
   - Отредактировать файл конфигурации SSH:
     ```bash
     sudo nano /etc/ssh/sshd_config
     ```
   - Установить параметр:
     ```
     PermitRootLogin no
     ```
   - Перезапустить SSH:
     ```bash
     sudo systemctl restart sshd 2>/dev/null || sudo systemctl restart ssh
     ```
---

7. **Установить Go**:
   ```bash
   sudo rm -rvf /usr/local/go/
   wget https://golang.org/dl/go1.23.4.linux-amd64.tar.gz
   sudo tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz
   rm go1.23.4.linux-amd64.tar.gz
   ```
---

8. **Объявить переменные среды для Go** (например в ~/.profile):
```bash
nano ~/.profile
```
   ```bash
   export GOROOT=/usr/local/go
   export GOPATH=$HOME/go
   export GO111MODULE=on
   export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
   ```
   Применить переменные (если ~/.profile):
   ```bash
   source ~/.profile
   ```
---

## 📥 Как загрузить и запустить скрипт проверки?

1. **Установить wget (если не установлен)**:
   ```bash
   sudo apt install wget -y
   ```
2. **Скачать скрипт с GitHub**:
   ```bash
   wget https://raw.githubusercontent.com/ptzruslan/tools/refs/heads/main/validator/tech02/practice_tech_02_ru.sh -O practice_tech_02.sh
   ```
3. **Дать скрипту права на выполнение**:
   ```bash
   chmod +x practice_tech_02.sh
   ```
4. **Запустить скрипт (указав имя созданного пользователя)**:
   ```bash
   bash practice_tech_02.sh <имя_пользователя> # Пример: bash practice_tech_02.sh superman
   ```

## 📌 Что проверяет скрипт?
- Создан ли пользователь и есть ли у него права sudo
- Обновлена ли система
- Установлены ли необходимые пакеты
- Отключён ли root-доступ по SSH
- Работает ли SSH
- Установлен ли Go и правильно ли объявлены переменные среды

Если всё выполнено корректно, студент увидит ✅ в консоли. Если найдены ошибки, появятся ❌ или ⚠️ с рекомендациями.
