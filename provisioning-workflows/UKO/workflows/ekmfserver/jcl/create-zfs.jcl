//**********************************************************************/
//* Copyright Contributors to the zOS-Workflow Project.                */
//* SPDX-License-Identifier: Apache-2.0                                */
//**********************************************************************/
//*******************************************************
//* Define new zfs for the configuration
//*******************************************************
//DEFINE   EXEC PGM=IDCAMS,REGION=6144K
//SYSPRINT DD   SYSOUT=*
//AMSDUMP  DD   SYSOUT=*
//SYSIN    DD   *
 DEFINE CLUSTER ( -
            NAME( -
            ${instance-EKMF_FILE_SYSTEM_HLQ}.${instance-EKMF_WEB_STC}) -
            LINEAR CYL(300 10) SHAREOPTIONS(2) -
#if(${instance-EKMF_ZFS_DATACLASS} && $!{instance-EKMF_ZFS_DATACLASS} != "")
      DATACLAS(${instance-EKMF_ZFS_DATACLASS}))
#else
      #if(${instance-EKMF_ZOS_VSAM_VOLUME} != "SMS")
      VOLUME(${instance-EKMF_ZOS_VSAM_VOLUME}))
      #else
      )
      #end
#end
/*
//*******************************************************
//* Format new config zfs
//*******************************************************
//CREATE   EXEC   PGM=IOEAGFMT,REGION=0M,
// PARM=('-aggregate ${instance-EKMF_FILE_SYSTEM_HLQ}.${instance-EKMF_WEB_STC} -compat')
//SYSPRINT DD     SYSOUT=*
//STDOUT   DD     SYSOUT=*
//STDERR   DD     SYSOUT=*
//SYSUDUMP DD     SYSOUT=*
//CEEDUMP  DD     SYSOUT=*
//*
//*******************************************************
//* MKDIR into which to mount the config directory
//*******************************************************
//CREATDIR EXEC PGM=IKJEFT01,REGION=64M,DYNAMNBR=99,COND=(0,LT)
//SYSTSPRT  DD SYSOUT=*
//SYSTSIN   DD *
  PROFILE MSGID WTPMSG
  MKDIR +
'${instance-EKMF_ZFS_MOUNTPOINT}/servers/${instance-EKMF_WEB_STC}' +
        MODE(7,5,5)
/*
#if(${instance-WLP_OUTPUT_DIR} && $!{instance-WLP_OUTPUT_DIR} != "")
//*******************************************************
//* Define new zfs for the output directory (logs, ect...)
//*******************************************************
//DEFINEO   EXEC PGM=IDCAMS,REGION=6144K
//SYSPRINT DD   SYSOUT=*
//AMSDUMP  DD   SYSOUT=*
//SYSIN    DD   *
 DEFINE CLUSTER ( -
            NAME( -
            ${instance-EKMF_FILE_SYSTEM_HLQ}.${instance-EKMF_WEB_STC}.OUTPUT) -
            LINEAR CYL(300 10) SHAREOPTIONS(2) -
#if(${instance-EKMF_ZFS_DATACLASS} && $!{instance-EKMF_ZFS_DATACLASS} != "")
      DATACLAS(${instance-EKMF_ZFS_DATACLASS}))
#else
      #if(${instance-EKMF_ZOS_VSAM_VOLUME} != "SMS")
      VOLUME(${instance-EKMF_ZOS_VSAM_VOLUME}))
      #else
      )
      #end
#end
/*
//*******************************************************
//* Format new output zfs
//*******************************************************
//CREATEO   EXEC   PGM=IOEAGFMT,REGION=0M,
// PARM=('-aggregate ${instance-EKMF_FILE_SYSTEM_HLQ}.${instance-EKMF_WEB_STC}.OUTPUT -compat')
//SYSPRINT DD     SYSOUT=*
//STDOUT   DD     SYSOUT=*
//STDERR   DD     SYSOUT=*
//SYSUDUMP DD     SYSOUT=*
//CEEDUMP  DD     SYSOUT=*
//*
//*******************************************************
//* MKDIR into which to mount the output directory
//*******************************************************
//CREATDIO EXEC PGM=IKJEFT01,REGION=64M,DYNAMNBR=99,COND=(0,LT)
//SYSTSPRT  DD SYSOUT=*
//SYSTSIN   DD *
  PROFILE MSGID WTPMSG
  MKDIR +
'${instance-WLP_OUTPUT_DIR}/${instance-EKMF_WEB_STC}' +
        MODE(7,7,5)
/*
#end