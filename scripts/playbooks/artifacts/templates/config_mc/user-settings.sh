#!/usr/bin/bash

#####  ================  eisupport and engine user settings  ============== ####

## -------------------  eisupport user -----------------##   

useradd eisupport 
echo "eisupport:W00dl@nds" | chpasswd

mkdir -p /home/eisupport/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4yU995G2/s+4zJ9keg1Y3I/y6LSabJVmzkPMwCf4e6rKlBPNhckqlAZza7uJUhjpWEiPFv5Rzi9PAzrddQiSplz05bH1qCtZAPvBcZLB6QGtbAeyKupu0yco2IZswq/7jVjiGHhX517td02EhDbqxpcpgrbO9wAeE9CqsAtIlCc7FALDGX+hu6MZiTnej618RetkWAXc3bfpZ080vL6zyYLuQaFCYhOzOu0GLgdOAkIFz1K7PeMUt1Vnh/lVQnz+ibQJMqUECHqVRQ0/q/nvs7898lGIZrgTzL/nqWSKYl/lnTOtfwboiYDiggkKEyjz8XavqDrMDawrPk0jIYBqR root@localhost.localdomain" >> /home/eisupport/.ssh/authorized_keys

chmod 600 /home/eisupport/.ssh/authorized_keys
chown -R eisupport:eisupport  /home/eisupport/.ssh

## --------------------------------------------------##   

## -------------------  engine user -----------------##   

mkdir -p /home/engine/.ssh

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4yU995G2/s+4zJ9keg1Y3I/y6LSabJVmzkPMwCf4e6rKlBPNhckqlAZza7uJUhjpWEiPFv5Rzi9PAzrddQiSplz05bH1qCtZAPvBcZLB6QGtbAeyKupu0yco2IZswq/7jVjiGHhX517td02EhDbqxpcpgrbO9wAeE9CqsAtIlCc7FALDGX+hu6MZiTnej618RetkWAXc3bfpZ080vL6zyYLuQaFCYhOzOu0GLgdOAkIFz1K7PeMUt1Vnh/lVQnz+ibQJMqUECHqVRQ0/q/nvs7898lGIZrgTzL/nqWSKYl/lnTOtfwboiYDiggkKEyjz8XavqDrMDawrPk0jIYBqR root@localhost.localdomain" >> /home/engine/.ssh/authorized_keys

echo "
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAuMlPfeRtv7PuMyfZHoNWNyP8ui0mmyVZs5DzMAn+HuqypQTz
YXJKpQGc2u7iVIY6VhIjxb+Uc4vTwM63XUIkqZc9OWx9agrWQD7wXGSwekBrWwHs
irqbtMnKNiGbMKv+41Y4hh4V+de7XdNhIQ26saXKYK2zvcAHhPQqrALSJQnOxQCw
xl/obujGYk53o+tfEXrZFgF3N236WdPNLy+s8mC7kGhQmITszrtBi4HTgJCBc9Su
z3jFLdVZ4f5VUJ8/om0CTKlBAh6lUUNP6v577O/PfJRiGa4E8y/56lkimJf5Z0zr
X8G6ImA4oIJChMo8/F2r6g6zA2sKz5NIyGAakQIDAQABAoIBAQCRfW8pIAGJPpH9
lRJOA/qNz7fcnlAXN4E48JeI61U54nBlnVBDGUnMQUjO1+c7xbOIsR+ZQw4PK7i9
xgR5WOqk3H9IBzN3mrC2RNfa5yxMFQxxy0ICuIp//aFInY0i9UjqlahLcMS8wi6z
4QpIjBbCaFa/aARtEhTZiaVPaakrnwaj+/myYkg3Ji8u1LW1FACmf5KnWBdz36AN
pMAhicSF0fE8JtoUAlgEv8YHS1RadAyaG7mhmfl1LrlHgSaBur5Q9kHxWOke6f9b
2iE9MXWz86Cp+FXazKexSJhpTSIgG85jhrgA4PiGBPmg13v+Bzi/LvOQ3tz3ktja
GTpyf/lBAoGBAN76p19kH8wrJTO6G8bPrHpXvkPVldnKM5m4q6YRT4Q7ALDqmkNQ
h1MVRrx2hjfLXsrb9iTMmLJDZPZMZiM+p+UsIKDbV6EOuhU6g5j7vTo074LHkK07
c/k6MYpYIQhb6X2afhaFSMoyeCN5rgehNeceA+t9+yXuoDpJxH5ypEr7AoGBANQm
u+tPOB6tvnYOLopcVX0A3CF7RFPw4lNi+oU64Skx04EXhB5LQ1DRjEfEAjfmDOzl
8BBBfPP2OdzYihNqT05WmmWIXVIy9ep5NlKP6AT3YR7CEUgF0yg67/DKyhrObuhl
HM39Mj4Xczy7vXa2yxLraPqbxYgMYP/E0zaNAnrjAoGBAJCOISnXaEHdir2xHsbR
5bhe3+tsMTzDOJakwSrlOA66jaUkQqP3NfPn7DbMBBFx199doIKU3T1cMbz3JJQe
z4vkArcl2/Z+7KZMi/oG4dM1dDztkd6sl2/wiSNuJOQdag7StIF3IQxskbQ181vg
6GgP7myh/MrHm7qODkQHoHk3AoGAG55/UH8bu0K7TPtDq9eheYinH+TAXH07ucdk
/ftQXOCTvHanSJpbxSXCsYUfFM/qVt0Ih9U+wzQHDG1UbHqmoHg92YILRCxGP6RQ
IieB+UOLbUmunkXD27Twj9SWwy6k2bRwL5EK/XJoGjwGynG5tljXbejhqniSGDoz
lSJ+dCkCgYBGvaFqpZNwTtXxL3PvI0LRY37EJ3cI8TAfIftAqaVb7FEmJcvDIAsd
Kavnv99PrnmhVw3Z/GNxi3Tf84kmMVIihL9xNYhtmgbqx0qnlHnETVX3oFZtohCS
F9yNiYCN1+0xK6cWaKzLp3pdbJsqGhKDnDKiStfouc8Z5disZHBz7w==
-----END RSA PRIVATE KEY-----
" >> /home/engine/.ssh/id.pem

chmod 600 /home/engine/.ssh/id.pem

# --------------------
CONF_DRIVE=$1
SSHFOLDER="$CONF_DRIVE/ssh_engine_folder"

echo "engine:engine" | chpasswd

rm -f /home/engine/.ssh/id_rsa /home/engine/.ssh/id_rsa.pub

cp $SSHFOLDER/id_rsa /home/engine/.ssh
cp $SSHFOLDER/id_rsa.pub /home/engine/.ssh
cat $SSHFOLDER/sshconfigfile >> /home/engine/.ssh/config
cat $SSHFOLDER/authorized_keys >> /home/engine/.ssh/authorized_keys

chmod 700 /home/engine/.ssh;
cd /home/engine/.ssh ;
chmod 644 id_rsa.pub ; chmod 600 id_rsa ; chmod 400 authorized_keys
chmod 644 known_hosts; chmod 600 config
chown -R engine:engine /home/engine/.ssh
# --------------------

cd /home/engine
cat <<EOF>.bashrc
if [ -f /opt/engine/etc/bashrc ]
then
. /opt/engine/etc/bashrc
fi
EOF

chown -R engine:engine /home/engine

echo "engine" >> /etc/cron.allow

## --------------------------------------------------##   

