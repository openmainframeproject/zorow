//**********************************************************************/
//* Copyright Contributors to the zOS-Workflow Project.                */
//* SPDX-License-Identifier: Apache-2.0                                */
//**********************************************************************/
//*--------------------------------------------------------------------
//* Unmount the ZFS
//*--------------------------------------------------------------------
//UNMOUNT EXEC PGM=BPXBATCH
//STDOUT  DD SYSOUT=*
//STDERR  DD SYSOUT=*
//STDPARM DD *
sh
if [ -d ${instance-UKO_ZFS_MOUNTPOINT}/servers/${instance-UKO_SERVER_STC_NAME}/PROVISION_OK ];
then
/usr/sbin/unmount -o immediate ${instance-UKO_ZFS_MOUNTPOINT}/servers/${instance-UKO_SERVER_STC_NAME};
#if(${instance-WLP_OUTPUT_DIR} && $!{instance-WLP_OUTPUT_DIR} != "")
/usr/sbin/unmount -o immediate ${instance-WLP_OUTPUT_DIR}/${instance-UKO_SERVER_STC_NAME};
#end

else echo "No mount directory to unmount.";
fi
/*
//*--------------------------------------------------------------------
//* Sleep for 10 seconds to allow the system to perform unmount
//*--------------------------------------------------------------------
//STEPX    EXEC PGM=BPXBATCH,PARM='sh /bin/sleep 10',COND=(4,LT)
//STDOUT   DD   SYSOUT=*
//STDERR   DD   SYSOUT=*
//STDIN    DD   DUMMY
//*--------------------------------------------------------------------
//* Delete the ZFS config dataset
//*-------------------------------------------------------------------
//DELETE    EXEC PGM=IDCAMS,REGION=1M
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 DELETE ${instance-UKO_FILE_SYSTEM_HLQ}.${instance-UKO_SERVER_STC_NAME}
 IF MAXCC EQ 8 THEN DO
   SET MAXCC = 0
   END
/*
#if(${instance-WLP_OUTPUT_DIR} && $!{instance-WLP_OUTPUT_DIR} != "")
//*--------------------------------------------------------------------
//* Delete the ZFS output dataset
//*-------------------------------------------------------------------
//DELETE    EXEC PGM=IDCAMS,REGION=1M
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 DELETE ${instance-UKO_FILE_SYSTEM_HLQ}.${instance-UKO_SERVER_STC_NAME}.OUTPUT
 IF MAXCC EQ 8 THEN DO
   SET MAXCC = 0
   END
/*
#end