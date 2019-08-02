//S1     EXEC USSBATCH,SU=Y
//STDOUT  DD SYSOUT=*
//STDERR  DD SYSOUT=*
//SYSIN   DD *
 chmod 755 ${instance-IIB_HOME_DIR}/ENVFILE
 mkdir /plex/var/mqsi/brokers/${instance-IIB_BROKER_NAME_LC}/tmp
 chown ${instance-IIB_STCUSER}:${instance-IIB_STCGROUP}          \
         /plex/var/mqsi/brokers/${instance-IIB_BROKER_NAME_LC}/tmp
 chmod 775 /plex/var/mqsi/brokers/${instance-IIB_BROKER_NAME_LC}/tmp
 ls -ld /plex/var/mqsi/brokers/${instance-IIB_BROKER_NAME_LC}/tmp
