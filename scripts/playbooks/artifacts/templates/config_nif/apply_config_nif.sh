#!/bin/bash
##############################################
# Script to apply configuration on NIF node  #
##############################################

cd /tmp
cp /root/config_drive_nif/rsync-3.1.2-4.el7.x86_64.rpm .
yum -y install ./rsync-3.1.2-4.el7.x86_64.rpm
rm -f rsync-3.1.2-4.el7.x86_64.rpm

cd /root
# directory definitions
CONF_DIRECTORY=/opt/engine/conf
CONF_EXAMPLES_DIRECTORY=/opt/engine/conf/examples
PMD_DIRECTORY=/opt/engine/conf/pmd.d
TENANT_DIRECTORY=/opt/engine/conf/tenant
PMD_EXAMPLES_DIRECTORY=/opt/engine/conf/examples/pmd.d
CONFIG_DRIVE=./config_drive_nif
PMD_CONFIG_DRIVE=$CONFIG_DRIVE/pmd
TENANT_CONFIG_DRIVE=$CONFIG_DRIVE/tenant
LICENSE_CONFIG_DRIVE=/export/home/telesoft/flexlm/licenses
SYSTEM_LIB=/usr/lib
SYSTEM_INIT=/opt/engine/init.d
PMON_WATCHDOG_DIRECTORY=/opt/pmon_watchdog/conf
PMON_DIAM_WATCHDOG_DIRECTORY=/opt/pmon_diamwatchdog/conf
PMON_WATCHDOG_CONFIG_DRIVE=$CONFIG_DRIVE/pmon_watchdog
PMON_DIAM_WATCHDOG_CONFIG_DRIVE=$CONFIG_DRIVE/pmon_diamwatchdog

#Pmon specific directories
PMON_DIAMLOC_CONFIG_DRIVE=$CONFIG_DRIVE/pmon_diamloctrack
PMON_DIAM_CONFIG_DRIVE=$CONFIG_DRIVE/pmon_diamsfw
PMON_SFWLOC_CONFIG_DRIVE=$CONFIG_DRIVE/pmon_loctrack
PMON_SFW_CONFIG_DRIVE=$CONFIG_DRIVE/pmon_sfw
PMON_DIAMLOC_DIRECTORY=/opt/pmon_diamloctrack
PMON_DIAM_DIRECTORY=/opt/pmon_diamsfw
PMON_SFW_DIRECTORY=/opt/pmon_sfw
PMON_SFWLOC_DIRECTORY=/opt/pmon_loctrack

#Nif config for insight
PCAP_DIRECTORY=/opt/engine/pcap
CONF_PCAP_DIRECTORY=/root/config_drive_nif/sfw_nif_insight
#
# copying configuration files
#

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
# copy pmon component specific files
#

for file in $PMON_SFW_CONFIG_DRIVE/*;
do
    if [ ! -d "$file" ]; then
        cp $file "$PMON_SFW_DIRECTORY/conf/"
    fi
done

for file in $PMON_DIAM_CONFIG_DRIVE/*;
do
    if [ ! -d "$file" ]; then
        cp $file "$PMON_DIAM_DIRECTORY/conf/"
    fi
done

for file in $PMON_DIAMLOC_CONFIG_DRIVE/*;
do
    if [ ! -d "$file" ]; then
        cp $file "$PMON_DIAMLOC_DIRECTORY/conf/"
    fi
done

for file in $PMON_SFWLOC_CONFIG_DRIVE/*;
do
    if [ ! -d "$file" ]; then
        cp $file "$PMON_SFWLOC_DIRECTORY/conf/"
    fi
done


for file in $PMON_WATCHDOG_CONFIG_DRIVE/*;
do
    if [ ! -d "$file" ]; then
        cp $file "$PMON_WATCHDOG_DIRECTORY/"
    fi
done

for file in $PMON_DIAM_WATCHDOG_CONFIG_DRIVE/*;
do
    if [ ! -d "$file" ]; then
        cp $file "$PMON_DIAM_WATCHDOG_DIRECTORY/"
    fi
done

chmod +x $SYSTEM_INIT/*
cp -p $CONF_DIRECTORY/ei.logrotate /etc/logrotate.d/

mkdir /opt/engine/data/expanded-rules
mkdir /opt/engine/data/expanded-rules/diameter
mkdir /opt/engine/data/expanded-rules/diameter/nif
mkdir /opt/engine/data/provisioning-data
mkdir /opt/engine/data/provisioning-data/diameter
mkdir /opt/engine/data/provisioning-data/diameter/dif
mkdir /opt/engine/data/provisioning-data/diameter/nif
mkdir /opt/engine/data/proxydata/
mkdir /opt/engine/data/proxydata/tenants-map/

#
# workaround for pmon multithreaded libraries error
#

for directory in $(find /opt/ -name "pmon_*" -type d); 
do 
    mv $directory/lib/libldcommsclient_shared.so.8.0.9 $directory/lib/libldcommsclient_shared.so.8.0.9_bk
    cp $directory/lib/libldcommsclient_shared-mt.so.8.0.9 $directory/lib/libldcommsclient_shared.so.8.0.9
done

cd /opt/engine/lib
mv libldcommsclient_shared.so.8.0.9 libldcommsclient_shared.so.8.0.9_bk
cp libldcommsclient_shared-mt.so.8.0.9 libldcommsclient_shared.so.8.0.9

# Add permission of tcpdum to engine user
groupadd pcap
usermod -a -G pcap engine
chgrp pcap /usr/sbin/tcpdump
setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump

mkdir -p /opt/engine/pcap/pickupSS7/blockedpcaps
mkdir -p /opt/engine/pcap/pickupDiameter/blockedpcaps
[[ ! -d $PCAP_DIRECTORY ]] && mkdir $PCAP_DIRECTORY
mkdir -p /opt/engine/pcap/pickupSS7/blockedpcaps
mkdir -p /opt/engine/pcap/pickupSS7/blockedpcapstemp
cp $CONF_PCAP_DIRECTORY/* $PCAP_DIRECTORY/

printf '* * * * * flock -n /opt/engine/pcap/runtcpdA.sh -c "sh /opt/engine/pcap/runtcpdA.sh 2>&1"\n* * * * * flock -n /opt/engine/pcap/runtcpdB.sh -c "sh /opt/engine/pcap/runtcpdB.sh 2>&1"\n'|crontab -u engine -

cp /opt/engine/bin/example_m3ua_scripts/sccpStack_relay.sh /opt/engine/bin/sccpStack0.sh
sed -i 's/stackNum=.*/stackNum=\"0\"/g' /opt/engine/bin/sccpStack0.sh
sed -i 's/ccureSetup=/#ccureSetup=/g' /opt/engine/bin/sccpStack0.sh
sed -i 's/##ccureSetup=*./ccureSetup=/g' /opt/engine/bin/sccpStack0.sh

cp /opt/engine/bin/example_m3ua_scripts/m3uaStack_relay.sh /opt/engine/bin/m3uaStack0.sh
sed -i 's/stackNum=.*/stackNum=\"0\"/g' /opt/engine/bin/m3uaStack0.sh
sed -i 's/ccureSetup=/#ccureSetup=/g' /opt/engine/bin/m3uaStack0.sh
sed -i 's/##ccureSetup=*./ccureSetup=/g' /opt/engine/bin/m3uaStack0.sh

cp /opt/engine/bin/example_m3ua_scripts/secure-mgmt-daemon.sh /opt/engine/bin/secure-mgmt-daemon.sh
cp /opt/engine/bin/example_m3ua_scripts/mgmt-daemon.sh /opt/engine/bin/mgmt-daemon.sh

chmod 755 /opt/engine/bin/*

file=$SYSTEM_LIB/libpcap.so.1.5.3
if [ -f "$file" ]; then
    ln -s $file  $SYSTEM_LIB/libpcap.so.0.9.4
fi

chmod +x /opt/engine/init.d/*
cp  /opt/engine/init.d/pmd_cpp.service /usr/lib/systemd/system/
chown -R engine:engine /opt /home/engine
systemctl enable flexlm

file=pmon_8.4.0.4_postinstall.sh
for directory in $(find /opt/ -name "pmon_*" -type d); 
do 
    cd $directory/bin/
    chmod +x *
    if [ -f "$file" ]; then
        sh $file
    fi
done

#Apply license file if available

file=$CONF_DIRECTORY/telesoft.lic
if [ -f "$file" ]; then
    sed -i 's/einif/einif einif.novalocal/g' /etc/hosts
    cp $file $LICENSE_CONFIG_DRIVE
fi

rm -rf /root/image_creation.out

cp $CONFIG_DRIVE/dist.xml /opt/engine/conf/
cp $CONFIG_DRIVE/dist.cfg /opt/engine/conf/

systemctl restart flexlm
systemctl enable pmd_cpp
systemctl start pmd_cpp
sleep 150s
systemctl restart pmd_cpp


