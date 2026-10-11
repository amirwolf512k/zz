FROM python:3.13-alpine

RUN apk add --no-cache \
        zip unzip ffmpeg whois openssh bash-completion bash git build-base binutils curl \
    && mkdir -p /var/run/sshd \
    && chmod 0755 /var/run/sshd \
    && usernamezz="a$(cat /dev/urandom | tr -dc '0-9' | head -c 7)" \
    && passwordzz="A$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 10)" \
    && rootpass="R$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 12)" \
    && adduser -D -u 1000 -s /bin/bash "$usernamezz" \
    && echo "$usernamezz:$passwordzz" | chpasswd \
    && echo "root:$rootpass" | chpasswd \
    && sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && echo "AllowUsers $usernamezz root" >> /etc/ssh/sshd_config \
    && echo "export PS1='[amirwolf512]:\w\$ '" >> /home/"$usernamezz"/.bashrc \
    && echo -e "USERNAME: $usernamezz\nPASSWORD: $passwordzz\nROOT_PASSWORD: $rootpass" > /etc/.ssh_creds \
    && ssh-keygen -A \
    && echo -e "Telegram:@amir_wolf512 HI:3\n\n==========>\n" > /etc/motd \
    && echo -e '#!/bin/bash\nif [ -f /etc/.ssh_creds ]; then\n  echo -e "\\n=========================================\\n  SSH CREDENTIALS (BUILD TIME):"\n  cat /etc/.ssh_creds\n  echo -e "=========================================\\n"\nfi\nexec /usr/sbin/sshd -D -o Port=8080' > /entrypoint.sh \
    && chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
