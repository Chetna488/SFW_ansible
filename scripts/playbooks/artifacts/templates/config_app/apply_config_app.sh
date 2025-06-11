#!/bin/bash
##############################################
# Script to apply configuration on APP node  #
##############################################

cd /tmp
cp /root/config_drive_app/rsync-3.1.2-4.el7.x86_64.rpm .
yum -y install ./rsync-3.1.2-4.el7.x86_64.rpm
rm -f rsync-3.1.2-4.el7.x86_64.rpm

cd /root

# directory definitions
CONF_DIRECTORY=/opt/engine/conf
CONF_EXAMPLES_DIRECTORY=/opt/engine/conf/examples
PMD_DIRECTORY=/opt/engine/conf/pmd.d
PMD_EXAMPLES_DIRECTORY=/opt/engine/conf/examples/pmd.d
CONFIG_DRIVE=./config_drive_app
PMD_CONFIG_DRIVE=./config_drive_app/pmd
RABBIT_CONFIG_FILE=./config_drive_app/rabbit/rabbitmq-env.conf
RABBIT_INSTALLATION_DIRECTORY=/opt/rabbitmq/etc/rabbitmq
DATA_DIRECTORY=/opt/engine/data
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
rm $PMD_DIRECTORY/firewall_pmd.xml

#
# copying rabbitmq-env.conf file
#

if [ "$RABBIT_CONFIG_FILE" != "RABBIT_INSTALLATION_DIRECTORY/" ]; then
        cp $RABBIT_CONFIG_FILE "$RABBIT_INSTALLATION_DIRECTORY/"
fi

#
# make extra directories
#

mkdir $DATA_DIRECTORY/sub-store 
mkdir $DATA_DIRECTORY/sub-store/provisioning-data 
mkdir $DATA_DIRECTORY/expanded-rules
mkdir $DATA_DIRECTORY/expanded-rules/gtp
mkdir $DATA_DIRECTORY/expanded-rules/gtp/app 
mkdir $DATA_DIRECTORY/provisioning-data/ 
mkdir $DATA_DIRECTORY/provisioning-data/diameter/ 
mkdir $DATA_DIRECTORY/provisioning-data/diameter/app 
mkdir $DATA_DIRECTORY/provisioning-data/admi
mkdir $DATA_DIRECTORY/pcap/
mkdir $DATA_DIRECTORY/pcap/app
mkdir $DATA_DIRECTORY/pcap/apptmp
mkdir /opt/engine/hz-config-server
mkdir /opt/engine/hz-config-server/persist

chmod +x /opt/engine/init.d/*
cp /opt/engine/init.d/pmd_cpp.service /usr/lib/systemd/system/
cp /opt/engine/init.d/rabbitmq-server /etc/init.d/
chown -R engine:engine /opt /home/engine

#file=$PMD_DIRECTORY/cfgsvr_pmd.xml
#if [ -f "$file" ]; then
#    sed -i 's/hzconfigserver/\/opt\/engine\/bin\/hzconfigserver/g'  $file
#fi

#file=$PMD_DIRECTORY/ld_pmd.xml
#if [ -f "$file" ]; then
#    sed -i 's/loaddirector/\/opt\/engine\/bin\/loaddirector/g'  $file
#fi

########## starting rabbitmq with basic configuration
su -c "mkdir -p /opt/rabbitmq/var/log/rabbitmq/" - engine
su -c "/opt/rabbitmq/sbin/rabbitmq-server -detached" - engine
sleep 30s
su -c "/opt/rabbitmq/sbin/rabbitmqctl add_user engine engine" - engine
su -c "/opt/rabbitmq/sbin/rabbitmqctl set_user_tags engine administrator" - engine
su - engine /opt/rabbitmq/sbin/rabbitmqctl set_permissions engine ".*" ".*" ".*" 
su -c "edrctl create -y" - engine

systemctl enable pmd_cpp
systemctl start pmd_cpp
rm -f /root/image_creation.out

chkconfig rabbitmq-server on
service rabbitmq-server start


