function install_postfix () {
  echo "$DOMAIN_NAME" > /etc/mailname

  postconf -e myhostname=$VIRTUAL_HOST
  postconf -e mydestination=$DOMAIN_NAME,$VIRTUAL_HOST,localhost.localdomain,localhost
  postconf -e mynetworks='127.0.0.1/32 192.168.0.0/16 172.16.0.0/12 10.0.0.0/8'
  postconf -e smtpd_relay_restrictions='permit_mynetworks permit_sasl_authenticated defer_unauth_destination'

  # setup the relay host
  postconf -e smtp_sasl_auth_enable=yes
  postconf -e relayhost=[$SMTP_RELAY_HOST]:$SMTP_RELAY_PORT
  postconf -e smtp_sasl_security_options=noanonymous
  postconf -e smtp_sasl_password_maps=static:$SMTP_RELAY_USER:$SMTP_RELAY_PASS

  cat >> /scripts/postfix.sh <<EOF
#!/bin/bash
/usr/sbin/postfix start
tail -F /var/log/mail.log
EOF
  chmod +x /scripts/postfix.sh

  mkdir -p /etc/supervisor/conf.d
  cat > /etc/supervisor/conf.d/postfix.conf <<EOF
[program:postfix]
command=/scripts/postfix.sh
EOF
}
