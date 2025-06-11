#!/bin/bash
#################################################
# Script to apply configuration on Int node #
#################################################

cd /root
CONFIG_DRIVE=/root/config_drive_int
CONF_DIRECTORY=/opt/analytics/conf
DIA_DIRECTORY=/opt/analytics/bin/diameterScripts
SS7_DIRECTORY=/opt/analytics/bin/ss7Scripts
CONF_EXAMPLE_DIRECTORY=/opt/analytics/conf/examples
DATA_DIRECTORY=/data/analytics
BIN_DIRECTORY=/opt/analytics/bin
DIA_SCRIPTS=$CONFIG_DRIVE/diameterScripts
SS7_SCRIPTS=$CONFIG_DRIVE/ss7Scripts
PCAP_SCRIPTS=$CONFIG_DRIVE/pcap
mkdir -p /opt/engine/pcap/smpp
mkdir -p /opt/analytics/traces/temp

[[ ! -d $CONF_DIRECTORY ]] && mkdir $CONF_DIRECTORY
cp $CONF_EXAMPLE_DIRECTORY/insight_v2.conf $CONF_DIRECTORY
cp $CONFIG_DRIVE/*conf $CONF_DIRECTORY
cp $CONF_EXAMPLE_DIRECTORY/numana.conf $CONF_DIRECTORY
cp $DIA_SCRIPTS/* $DIA_DIRECTORY*
cp $SS7_SCRIPTS/* $SS7_DIRECTORY
cp $PCAP_SCRIPTS/* $BIN_DIRECTORY
cp $CONFIG_DRIVE/getSMPPData.sh /opt/engine/bin

mkdir -p  /opt/insight-exporter/conf/tenant-app-configs-tmp
\cp $CONFIG_DRIVE/hz-proxy-server* /opt/engine/conf/
rm -rf /opt/engine/conf/pmd.d/insight*
echo "source /opt/engine/etc/bashrc" >> /root/.bashrc
sed -i 's/engine/insight-exporter/g' /opt/insight-exporter/conf/insight-exporter.json
\cp $CONFIG_DRIVE/insight-exporter/*.json /opt/insight-exporter/conf/
\cp $CONFIG_DRIVE/insight-exporter/*.xml /opt/insight-exporter/conf/
\cp $CONFIG_DRIVE/insight-exporter/*.sh /opt/insight-exporter/bin

systemctl enable pmd_cpp
systemctl start pmd_cpp

crontab -u engine /root/config_drive_int/engine-user-cronlist.txt

chown -R engine:engine /opt /data /home/engine

#printf '* * * * * flock -n /opt/analytics/bin/ss7Scripts/pcap1-ss7.sh -c " sh /opt/analytics/bin/ss7Scripts/pcap1-ss7.sh >> /opt/analytics/logs/load1-ss7.log 2>&1"\n* * * * * flock -n /opt/analytics/bin/diameterScripts/pcap1-diameter.sh -c " sh /opt/analytics/bin/diameterScripts/pcap1-diameter.sh >> /opt/analytics/logs/load1-diameter.log 2>&1"\n* * * * * flock -n /opt/analytics/bin/pcap2.sh -c "sh /opt/analytics/bin/pcap2.sh >> /opt/analytics/logs/load2.log 2>&1"\n20 * * * * flock -n /opt/analytics/bin/hourly.sh -c "sh /opt/analytics/bin/hourly.sh >> /opt/analytics/logs/hourly.log 2>&1"\n0 1 * * * sh /opt/analytics/bin/nightly.sh > /opt/analytics/logs/nightly.log 2>&1\n' |crontab -u engine -
printf '* * * * * flock -n /opt/analytics/bin/ss7Scripts/pcap1-ss7.sh -c " sh /opt/analytics/bin/ss7Scripts/pcap1-ss7.sh >> /opt/analytics/logs/load1-ss7.log 2>&1"\n* * * * * flock -n /opt/analytics/bin/diameterScripts/pcap1-diameter.sh -c " sh /opt/analytics/bin/diameterScripts/pcap1-diameter.sh >> /opt/analytics/logs/load1-diameter.log 2>&1"\n* * * * * flock -n /opt/analytics/bin/pcap2.sh -c "sh /opt/analytics/bin/pcap2.sh >> /opt/analytics/logs/load2.log 2>&1"\n20 * * * * flock -n /opt/analytics/bin/hourly.sh -c "sh /opt/analytics/bin/hourly.sh >> /opt/analytics/logs/hourly.log 2>&1"\n' |crontab -u engine -
chown -R engine:engine /home/engine/
chown -R engine:engine /home/engine/

systemctl restart pmd_cpp
rm -f /root/image_creation.log

