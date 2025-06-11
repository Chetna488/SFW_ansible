#!/bin/bash
################################################
# Script to apply configuration on mc node #
################################################

cd /tmp
cp /root/config_drive_mc/rsync-3.1.2-4.el7.x86_64.rpm .
yum -y install ./rsync-3.1.2-4.el7.x86_64.rpm
rm -f rsync-3.1.2-4.el7.x86_64.rpm

cd /root

# directory definitions
CONF_DIRECTORY=/opt/engine/conf
CONF_EXAMPLES_DIRECTORY=/opt/engine/conf/examples
PMD_DIRECTORY=/opt/engine/conf/pmd.d
PMD_EXAMPLES_DIRECTORY=/opt/engine/conf/examples/pmd.d
CONFIG_DRIVE=/root/config_drive_mc
PMD_CONFIG_DRIVE=/root/config_drive_mc/pmd
TENANT_CONFIG_DRIVE=/root/config_drive_mc/tenant
NGINX_DRIVE=/etc/nginx/conf.d
TENANT_DIRECTORY=$CONF_DIRECTORY/tenant
mkdir -p $TENANT_DIRECTORY
mkdir -p /opt/engine/pcap/smpp
mkdir -p /opt/analytics/traces/temp
cp $CONFIG_DRIVE/getSMPPData.sh /opt/engine/bin
systemctl stop nginx

cp $CONFIG_DRIVE/nginx/default.conf $NGINX_DRIVE/
if [ ! -f "*.crt" ]; then
    echo "Please add the certificate file for nginx"
fi
cp $CONFIG_DRIVE/nginx/nginx.conf /etc/nginx/
cp $CONFIG_DRIVE/nginx/provisioning/nginx.conf /opt/engine/provisioning/applications/provisioning/
cp $CONFIG_DRIVE/nginx/server/options.json /opt/engine/provisioning/applications/provisioning/server/config/
cp $CONFIG_DRIVE/insight/index.js  /opt/engine/provisioning/applications/insight/server/config/
cp $CONFIG_DRIVE/insight-search/index.js /opt/engine/provisioning/applications/insight-search/server/config/
cp $CONFIG_DRIVE/index.js /opt/engine/provisioning/applications/provisioning/server/node_modules/ei-firewall-graphql/dist/
cp $CONFIG_DRIVE/ansible_inventory_hosts.txt /etc/ansible/hosts
cp $CONFIG_DRIVE/add_eihosts_all.sh /etc/ansible/
chmod 755 /etc/ansible/add_eihosts_all.sh

systemctl start nginx

#
# copying configuration files
#

## Crontab settings for engine user

cp $CONFIG_DRIVE/rsync-statistics /opt/engine/edrReports/bin/
cp $CONFIG_DRIVE/edringest.sh /opt/engine/edrReports/bin/
chmod 755  /opt/engine/edrReports/bin/rsync-statistics  /opt/engine/edrReports/bin/edringest.sh
crontab -u engine /root/config_drive_mc/engine-user-cronlist.txt
cp $CONFIG_DRIVE/engine-user-cronlist-modified.txt /home/engine/
cp $CONFIG_DRIVE/mancon-server-raid-related-changes-script.sh /home/engine/
chmod 755 /home/engine/mancon-server-raid-related-changes-script.sh
sh /home/engine/mancon-server-raid-related-changes-script.sh


for file in $CONFIG_DRIVE/*;
do
    if [ ! -d "$file" ]; then
        cp $file "$CONF_DIRECTORY/"
    fi
done

#
# copying pmd files
#

for file in $PMD_CONFIG_DRIVE/*;
do
    if [ ! -d "$file" ]; then
        cp $file "$PMD_DIRECTORY/"
    fi
done

#
# copying tenant files
#

for file in $TENANT_CONFIG_DRIVE/*;
do
    if [ ! -d "$file" ]; then
        cp $file "$TENANT_DIRECTORY/"
    fi
done

#
# skipping grafana config for now
#
rm $PMD_DIRECTORY/grafana-proxy-pmd.xml
chmod 755 /opt/engine/provisioning/applications/insight
chmod 755 /opt/engine/provisioning/applications
chmod 755 /opt/engine/provisioning

chmod +x /opt/engine/init.d/*
cp /opt/engine/init.d/pmd_cpp.service  /usr/lib/systemd/system/
ln -s  /opt/node-v12.18.3-linux-x64/bin/node /usr/local/bin/node

 mkdir -p /opt/engine/edrReports/import/statistics/einif
 sed -i 's/NIFS=.*/NIFS=( einif )/g' /opt/engine/edrReports/bin/rsync-statistics


chown -R engine:engine /opt /home/engine

sleep 20s
TENANT_SCRIPT=/opt/engine/provisioning/applications/provisioning/server/scripts
TENANT_DIRECTORY=/opt/engine/conf/tenant

for file in $TENANT_DIRECTORY/*;
do
    if [ -f "$file" ]; then
        key=$(cat $file|grep "KEY="|awk -F'=' '{print $2}')
        sfw_list=$(cat $file|grep "SFW_LIST="|awk -F'=' '{print $2}')
        tenant_name=$(cat $file|grep "TENANT_NAME="|awk -F'=' '{print $2}')
        country_code=$(cat $file|grep "COUNTRY_CODE="|awk -F'=' '{print $2}')
        realm=$(cat $file|grep "REALM="|awk -F'=' '{print $2}')
        E164_code=$(cat $file|grep "E164_CODE="|awk -F'=' '{print $2}')
        E212_code=$(cat $file|grep "E212_CODE="|awk -F'=' '{print $2}')

        su -c "$TENANT_SCRIPT/createtenant.js -i $key -n $tenant_name -s $sfw_list -d -o $country_code -r $realm -g $E164_code -m $E212_code" - engine
    fi
done
sleep 30

systemctl enable pmd_cpp
systemctl start pmd_cpp
rm -f /root/image_creation.log
