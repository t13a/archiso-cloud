#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/zsh root
cp -aT /etc/skel/ /root/
chmod 700 /root

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

systemctl enable pacman-init.service choose-mirror.service
systemctl set-default multi-user.target

# sed -i 's/^#\( - \[ \*log_base, \*log_syslog \]\)/\1/g' /etc/cloud/cloud.cfg.d/05_logging.cfg
# sed -i 's/^\( - \[ \*log_base, \*log_file \]\)/# \1/g' /etc/cloud/cloud.cfg.d/05_logging.cfg
# sed -i 's/^\(output: .*\)/# \1/g' /etc/cloud/cloud.cfg.d/05_logging.cfg

systemctl enable \
    cloud-init-local.service \
    cloud-init.service \
    cloud-config.service \
    cloud-final.service

passwd -l root