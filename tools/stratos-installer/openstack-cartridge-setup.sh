#!/bin/bash
# ----------------------------------------------------------------------------
#
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing,
#  software distributed under the License is distributed on an
#  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#  KIND, either express or implied.  See the License for the
#  specific language governing permissions and limitations
#  under the License.
#
# ----------------------------------------------------------------------------
#
#  This script is invoked by setup.sh for setting up Apache Stratos Cartridges for OpenStack.
# ----------------------------------------------------------------------------

# Die on any error:
set -e

SLEEP=60
export LOG=$log_path/stratos-openstack-cartridge-setup.log

source "./conf/setup.conf"

if [[ ! -d $log_path ]]; then
    mkdir -p $log_path
fi
   
#mkdir -p /var/www/notify
#cp -f ./resources/notify.php /var/www/notify/index.php
#echo "apache2 will be restarted and if start successfull you configuration upto this point is OK." >> $LOG
#echo "apache2 will be restarted and if start successfull you configuration upto this point is OK."
#apachectl stop
#sleep 5
#apachectl start

echo "Creating payload directory ... " | tee $LOG
if [[ ! -d $cc_path/repository/resources/payload ]]; then
   mkdir -p $cc_path/repository/resources/payload
fi

echo "Creating cartridges directory ... " | tee $LOG
if [[ ! -d $cc_path/repository/deployment/server/cartridges/ ]]; then
   mkdir -p $cc_path/repository/deployment/server/cartridges/
fi


# Copy the cartridge specific configuration files into the CC
if [ "$(find ./cartridges/ -type f)" ]; then
    cp -f ./cartridges/*.xml $cc_path/repository/deployment/server/cartridges/
fi
if [ "$(find ./cartridges/payload/ -type f)" ]; then
    cp -f ./cartridges/payload/*.txt $cc_path/repository/resources/payload/
fi
if [ "$(find ./cartridges/services/ -type f)" ]; then
    cp -f ./cartridges/services/*.xml $cc_path/repository/deployment/server/services/
fi

pushd $cc_path
echo "Updating repository/deployment/server/cartridges/mysql.xml" | tee $LOG
# <iaasProvider type="openstack" >
#    <imageId>nova/d6e5dbe9-f781-460d-b554-23a133a887cd</imageId>
#    <property name="keyPair" value="stratos-demo"/>
#    <property name="instanceType" value="nova/1"/>
#    <property name="securityGroups" value="default"/>
#    <!--<property name="payload" value="resources/as.txt"/>-->
# </iaasProvider>
 

cp -f repository/deployment/server/cartridges/mysql.xml repository/deployment/server/cartridges/mysql.xml.orig
cat repository/deployment/server/cartridges/mysql.xml.orig | sed -e "s@<property name=\"keyPair\" value=\"*.*\"/>@<property name=\"keyPair\" value=\"$openstack_keypair_name\"/>@g" > repository/deployment/server/cartridges/mysql.xml

cp -f repository/deployment/server/cartridges/mysql.xml repository/deployment/server/cartridges/mysql.xml.orig
cat repository/deployment/server/cartridges/mysql.xml.orig | sed -e "s@<property name=\"instanceType\" value=\"*.*\"/>@<property name=\"instanceType\" value=\"$openstack_instance_type_tiny\"/>@g" > repository/deployment/server/cartridges/mysql.xml

cp -f repository/deployment/server/cartridges/mysql.xml repository/deployment/server/cartridges/mysql.xml.orig
cat repository/deployment/server/cartridges/mysql.xml.orig | sed -e "s@<property name=\"securityGroups\" value=\"*.*\"/>@<property name=\"securityGroups\" value=\"$openstack_security_group\"/>@g" > repository/deployment/server/cartridges/mysql.xml

cp -f repository/deployment/server/cartridges/mysql.xml repository/deployment/server/cartridges/mysql.xml.orig
cat repository/deployment/server/cartridges/mysql.xml.orig | sed -e "s@<imageId>*.*</imageId>@<imageId>$nova_region/$mysql_cartridge_image_id</imageId>@g" > repository/deployment/server/cartridges/mysql.xml

cp -f repository/deployment/server/cartridges/mysql.xml repository/deployment/server/cartridges/mysql.xml.orig
cat repository/deployment/server/cartridges/mysql.xml.orig | sed -e "s@STRATOS_DOMAIN@$stratos2_domain@g" > repository/deployment/server/cartridges/mysql.xml



echo "Updating repository/deployment/server/cartridges/php.xml" | tee $LOG
# <iaasProvider type="openstack" >
#     <imageId>nova/250cd0bb-96a3-4ce8-bec8-7f9c1efea1e6</imageId>
#     <property name="keyPair" value="stratos-demo"/>
#     <property name="instanceType" value="nova/1"/>
#     <property name="securityGroups" value="default"/>
#     <!--<property name="payload" value="resources/as.txt"/>-->
# </iaasProvider>

cp -f repository/deployment/server/cartridges/php.xml repository/deployment/server/cartridges/php.xml.orig
cat repository/deployment/server/cartridges/php.xml.orig | sed -e "s@<property name=\"keyPair\" value=\"*.*\"/>@<property name=\"keyPair\" value=\"$openstack_keypair_name\"/>@g" > repository/deployment/server/cartridges/php.xml

cp -f repository/deployment/server/cartridges/php.xml repository/deployment/server/cartridges/php.xml.orig
cat repository/deployment/server/cartridges/php.xml.orig | sed -e "s@<property name=\"instanceType\" value=\"*.*\"/>@<property name=\"instanceType\" value=\"$openstack_instance_type_tiny\"/>@g" > repository/deployment/server/cartridges/php.xml

cp -f repository/deployment/server/cartridges/php.xml repository/deployment/server/cartridges/php.xml.orig
cat repository/deployment/server/cartridges/php.xml.orig | sed -e "s@<property name=\"securityGroups\" value=\"*.*\"/>@<property name=\"securityGroups\" value=\"$openstack_security_group\"/>@g" > repository/deployment/server/cartridges/php.xml

#cp -f repository/deployment/server/cartridges/php.xml repository/deployment/server/cartridges/php.xml.orig
#cat repository/deployment/server/cartridges/php.xml.orig | sed -e "s@<imageId>*.*</imageId>@<imageId>$nova_region/$php_cartridge_image_id</imageId>@g" > repository/deployment/server/cartridges/php.xml

cp -f repository/deployment/server/cartridges/php.xml repository/deployment/server/cartridges/php.xml.orig
cat repository/deployment/server/cartridges/php.xml.orig | sed -e "s@<imageId>*.*</imageId>@<imageId>$nova_region/$php_cartridge_image_id</imageId>@g" > repository/deployment/server/cartridges/php.xml

cp -f repository/deployment/server/cartridges/php.xml repository/deployment/server/cartridges/php.xml.orig
cat repository/deployment/server/cartridges/php.xml.orig | sed -e "s@STRATOS_DOMAIN@$stratos2_domain@g" > repository/deployment/server/cartridges/php.xml

popd # cc_path