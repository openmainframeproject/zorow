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
mkdir -p /${_workflow-systemName}/var/mqsi/brokers
ls -alF /${_workflow-systemName}${instance-IIB_WORK_DIR_SYMLINK}
ln -s /plex${instance-IIB_WORK_DIR} /${_workflow-systemName}${instance-IIB_WORK_DIR_SYMLINK}
ls -alF /${_workflow-systemName}${instance-IIB_WORK_DIR_SYMLINK}
