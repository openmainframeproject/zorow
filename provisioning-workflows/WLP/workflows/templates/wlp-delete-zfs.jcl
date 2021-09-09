//******************************************************************
//* Copyright Contributors to the zOS-Workflow Project.            *
//* PDX-License-Identifier: Apache-2.0                             *
//******************************************************************
//*******************************************************
//* Unmount zfs if mounted
//*******************************************************
//UNMOUNT  EXEC PGM=BPXBATCH
//STDOUT   DD   SYSOUT=*
//STDERR   DD   SYSOUT=*
//STDPARM  DD   *
sh
mountInfo=`df ${instance-WLP_USER_DIR}`;
echo $mountInfo;
echo $mountInfo | grep -q "(${instance-FILE_SYSTEM_HLQ}.${_workflow-softwareServiceInstanceName})";
if [ $? ];
then
/usr/sbin/unmount -o immediate ${instance-WLP_USER_DIR};
/bin/sleep 5;
else echo "Skip - file system was not mounted.";
fi
/*
//*******************************************************
//* Deallocate zfs
//*******************************************************
//DEALLOC  EXEC PGM=IDCAMS
//SYSPRINT DD   SYSOUT=*
//SYSUDUMP DD   SYSOUT=*
//AMSDUMP  DD   SYSOUT=*
//DASD0    DD   DISP=OLD,UNIT=3390,VOL=SER=${instance-VOLUME}
//SYSIN    DD   *
 LISTCAT ENTRIES('${instance-FILE_SYSTEM_HLQ}.${_workflow-softwareServiceInstanceName}')
 IF MAXCC EQ 0 THEN DO
   DELETE '${instance-FILE_SYSTEM_HLQ}.${_workflow-softwareServiceInstanceName}' CLUSTER
   END
 ELSE SET MAXCC = 0
/*
