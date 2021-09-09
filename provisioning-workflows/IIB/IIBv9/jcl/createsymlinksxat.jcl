//******************************************************************
//* Copyright Contributors to the zOS-Workflow Project.            *
//* PDX-License-Identifier: Apache-2.0                             *
//******************************************************************
//S1     EXEC USSBATCH,SU=Y
//STDOUT  DD SYSOUT=*
//STDERR  DD SYSOUT=*
//* create directories if they do not yet exist
//* then create symbolic link
//SYSIN   DD *
umask 022
mkdir -p /${instance-IIB_PLEX}1/var/mqsi/brokers
mkdir -p /${instance-IIB_PLEX}2/var/mqsi/brokers
mkdir -p /${instance-IIB_PLEX}3/var/mqsi/brokers

ls -alF /${instance-IIB_PLEX}1${instance-IIB_WORK_DIR_SYMLINK}
ls -alF /${instance-IIB_PLEX}2${instance-IIB_WORK_DIR_SYMLINK}
ls -alF /${instance-IIB_PLEX}3${instance-IIB_WORK_DIR_SYMLINK}
ln -s /plex${instance-IIB_WORK_DIR} /${instance-IIB_PLEX}1${instance-IIB_WORK_DIR_SYMLINK}
ln -s /plex${instance-IIB_WORK_DIR} /${instance-IIB_PLEX}2${instance-IIB_WORK_DIR_SYMLINK}
ln -s /plex${instance-IIB_WORK_DIR} /${instance-IIB_PLEX}3${instance-IIB_WORK_DIR_SYMLINK}
ls -alF /${instance-IIB_PLEX}1${instance-IIB_WORK_DIR_SYMLINK}
ls -alF /${instance-IIB_PLEX}2${instance-IIB_WORK_DIR_SYMLINK}
ls -alF /${instance-IIB_PLEX}3${instance-IIB_WORK_DIR_SYMLINK}
/*
