//**********************************************************************/
//* Copyright Contributors to the zOS-Workflow Project.                */
//* SPDX-License-Identifier: Apache-2.0                                */
//**********************************************************************/
//COPYPROC EXEC PGM=IEBGENER,MEMLIMIT=0M
//SYSUT2 DD DISP=SHR,
//          DSN=${instance-UKO_ZOS_PROCLIB}(${instance-UKO_AGENT_STC_NAME})
//SYSPRINT DD SYSOUT=*
//SYSIN  DD *
//SYSUT1 DD DATA,DLM='@@'
//${instance-UKO_AGENT_STC_NAME} PROC M=${instance-UKO_AGENT_STC_NAME}
//*--------------------------------------------------------------------
//* Unified Key Orchestrator for z/OS    */
//*
//*--------------------------------------------------------------------
//${instance-UKO_AGENT_STC_NAME} EXEC  PGM=IKJEFT01,REGION=6M,TIME=1440
//STEPLIB  DD DSN=${instance-UKO_AGENT_RUN_HLQ},DISP=SHR 
//         DD DSN=${instance-TCPIP_HLQ}.SEZATCP,DISP=SHR
//*        DD DSN=CSF.SCSFMOD0,DISP=SHR
//KMGPARM  DD DSN=${instance-UKO_ZOS_PARMLIB}(&M),DISP=SHR
//SYSOUT   DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
KMGPTRAN
@@
/*
## Create the STCJOBS member if required
#if(${instance-UKO_STC_JOB_CARD} && $!{instance-UKO_STC_JOB_CARD} != "")
//COPY2 EXEC PGM=IEBGENER,MEMLIMIT=0M
//SYSUT2 DD DISP=SHR,
//          DSN=${instance-UKO_ZOS_STCJOBS}(${instance-UKO_AGENT_STC_NAME})
//SYSPRINT DD SYSOUT=*
//SYSIN  DD *
//SYSUT1 DD DATA,DLM='@@'
#set($jobcard = "//${instance-UKO_AGENT_STC_NAME} ")
#set($stc = "${instance-UKO_STC_JOB_CARD}")
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
//* Set proc order and then execute UKO
//*
//PROCLIB JCLLIB ORDER=${instance-UKO_ZOS_PROCLIB}
//UKO    EXEC ${instance-UKO_AGENT_STC_NAME}
@@
/*
#end