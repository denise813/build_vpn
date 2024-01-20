net_dev=eth0
# ppp安装ppp
yum -y install pptpd

vpn_ip=$(ip addr show ${net_dev}|grep inet|grep -v inet6|awk '{split($2, ip, "/"); print ip[1]}')
cat<< EOF /etc/pptpd.conf
localip ${vpn_ip}
remoteip 0.0.0.0
EOF

cat << EOF /etc/ppp/options.pptpd
ms-dns 8.8.8.8
ms-dns 8.8.4.4
EOF

cat << EOF /etc/ppp/chap-secrets
deise813	hy123456	*
EOF

cat << EOF /etc/sysctl.conf
net.ipv4.ip_forward = 1
EOF

sysctl -p

systemctl restart pptpd

systemctl enable pptpd

iptables -nL

route
