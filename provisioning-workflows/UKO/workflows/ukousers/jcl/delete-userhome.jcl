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
//STDPARM DD *,SYMBOLS=JCLONLY
sh
/usr/sbin/unmount -o immediate /u/${instance-UKO_SERVER_STC_USER};
if [ $? -gt 0 ]; then 
    echo "no web task user directory needed to be unmounted";
fi;
/usr/sbin/unmount -o immediate /u/${instance-UKO_AGENT_STC_USER};
if [ $? -gt 0 ]; then 
    echo "no agent task user directory needed to be unmounted";
fi;
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
//SYSIN    DD *,SYMBOLS=JCLONLY
 DELETE OMVS.MV3N.USERID.${instance-UKO_SERVER_STC_USER}
 IF MAXCC EQ 8 THEN DO
   SET MAXCC = 0
   END
 DELETE OMVS.MV3N.USERID.${instance-UKO_AGENT_STC_USER}
 IF MAXCC EQ 8 THEN DO
   SET MAXCC = 0
   END
/*
//*********************************************************************
//*              STEP - Create script in temp directory using BPXCOPY *
//*********************************************************************
//*
//REMOVE   EXEC PGM=BPXBATCH
//STDENV   DD *
_BPX_SHAREAS=YES
_BPX_SPAWN_SCRIPT=YES
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//STDPARM  DD *,SYMBOLS=JCLONLY,DLM=$$
SH
rm -rf /u/${instance-UKO_SERVER_STC_USER};
if [ $? -gt 0 ]; then 
    echo "no web task user directory needed to be deleted";
fi;
rm -rf /u/${instance-UKO_AGENT_STC_USER};
if [ $? -gt 0 ]; then 
    echo "no agent user directory needed to be deleted";
fi;
$$
/*