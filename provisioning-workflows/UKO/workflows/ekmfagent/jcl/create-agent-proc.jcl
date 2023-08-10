//**********************************************************************/
//* Copyright Contributors to the zOS-Workflow Project.                */
//* SPDX-License-Identifier: Apache-2.0                                */
//**********************************************************************/
//COPYPROC EXEC PGM=IEBGENER,MEMLIMIT=0M
//SYSUT2 DD DISP=SHR,
//          DSN=${instance-EKMF_ZOS_PROCLIB}(${instance-EKMF_AGENT_STC})
//SYSPRINT DD SYSOUT=*
//SYSIN  DD *
//SYSUT1 DD DATA,DLM='@@'
//${instance-EKMF_AGENT_STC} PROC M=${instance-EKMF_AGENT_STC}
//*--------------------------------------------------------------------
//* Licensed Materials - Property of IBM               */
//* EKMF                                               */
//* (C) Copyright IBM Corp. 2001, 2021                 */
//* IBM Enterprise Key Management Foundation (EKMF)    */
//*
//* PROCEDURE: EKMFCRY
//* PROCLIB  : SYS1.PROCLIB
//*--------------------------------------------------------------------
//${instance-EKMF_AGENT_STC} EXEC  PGM=IKJEFT01,REGION=6M,TIME=1440
//STEPLIB  DD DSN=${instance-EKMF_AGENT_RUN_HLQ},DISP=SHR 
//         DD DSN=${instance-TCPIP_HLQ}.SEZATCP,DISP=SHR
//*        DD DSN=CSF.SCSFMOD0,DISP=SHR
//KMGPARM  DD DSN=${instance-EKMF_ZOS_PARMLIB}(&M),DISP=SHR
//SYSOUT   DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
KMGPTRAN
@@
/*
## Create the STCJOBS member if required
#if(${instance-EKMF_STC_JOB_CARD} && $!{instance-EKMF_STC_JOB_CARD} != "")
//COPY2 EXEC PGM=IEBGENER,MEMLIMIT=0M
//SYSUT2 DD DISP=SHR,
//          DSN=${instance-EKMF_ZOS_STCJOBS}(${instance-EKMF_AGENT_STC})
//SYSPRINT DD SYSOUT=*
//SYSIN  DD *
//SYSUT1 DD DATA,DLM='@@'
#set($jobcard = "//${instance-EKMF_AGENT_STC} ")
#set($stc = "${instance-EKMF_STC_JOB_CARD}")
## Parse the jobcard passed in looking for ,
#foreach( $parm in $stc.split(","))
#set($temp = "${jobcard}${parm},")
##if over 70 characters then create new line instead
#if($temp.length() > 70)
${jobcard}
#set($temp = "//  ${parm},")
#end
#set($jobcard = $temp)
#end
## Remove the last , if needed
$jobcard.substring(0,$jobcard.lastIndexOf(","))
//*
//* Set proc order and then execute EKMF Web
//*
//PROCLIB JCLLIB ORDER=${instance-EKMF_ZOS_PROCLIB}
//EKMF    EXEC ${instance-EKMF_AGENT_STC}
@@
/*
#end