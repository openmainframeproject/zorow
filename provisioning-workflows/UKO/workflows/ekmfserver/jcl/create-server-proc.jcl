//**********************************************************************/
//* Copyright Contributors to the zOS-Workflow Project.                */
//* SPDX-License-Identifier: Apache-2.0                                */
//**********************************************************************/
//COPY1 EXEC PGM=IEBGENER,MEMLIMIT=0M
//SYSUT2 DD DISP=SHR,
//          DSN=${instance-EKMF_ZOS_PROCLIB}(${instance-EKMF_WEB_STC})
//SYSPRINT DD SYSOUT=*
//SYSIN  DD *
//SYSUT1 DD DATA,DLM='@@'
//${instance-EKMF_WEB_STC} PROC PARMS='${instance-EKMF_WEB_STC}'
//*------------------------------------------------------------------
//* EKMF Web Liberty Server Proc
//*------------------------------------------------------------------
//* PARMS   - server name
//* WLP_INSTALL_DIR- The path to the root of WebSphere Liberty Profile
//*           install.
//*           This path is used to find the product code.
//*------------------------------------------------------------------
//* JAVA_HOME must define the z/OS UNIX path up to, but not
//* including, the "bin" directory. e.g. /usr/lpp/java/J8.0_64
//* JVM_OPTIONS can be used to specify JVM options.
//* WLP_USER_DIR define the directory where user's servers are
//*              stored, but not including the 'servers' directory,
//*              e.g. /etc/liberty
//*------------------------------------------------------------------
//* Start the Liberty server
//*
//* STDOUT  - Destination for stdout (System.out)
//* STDERR  - Destination for stderr (System.err)
//* STDENV  - Initial z/OS UNIX environment for the specific
//*           server being started
//*
// SET WLPHOME='${instance-WLP_INSTALL_DIR}'
//*
//STEP1    EXEC PGM=BPXBATSL,REGION=0M,TIME=NOLIMIT,
//  PARM='PGM &WLPHOME./lib/native/zos/s390x/bbgzsrv --clean &PARMS.'
//STEPLIB  DD DSN=${instance-DB2_HLQ}.SDSNEXIT,DISP=SHR
//         DD DSN=${instance-DB2_HLQ}.SDSNLOAD,DISP=SHR
//         DD DSN=${instance-DB2_HLQ}.SDSNLOD2,DISP=SHR
//STDOUT   DD   SYSOUT=*
//STDERR   DD   SYSOUT=*
//STDIN    DD   DUMMY
//STDENV   DD   *
_BPX_SHAREAS=YES
JAVA_HOME=${instance-JAVA_HOME}
WLP_USER_DIR=${instance-EKMF_ZFS_MOUNTPOINT}
#JVM_OPTIONS=<Optional JVM parameters>
//*
// PEND
//
@@
/*
## Create the STCJOBS member if required
#if(${instance-EKMF_STC_JOB_CARD} && $!{instance-EKMF_STC_JOB_CARD} != "")
//COPY2 EXEC PGM=IEBGENER,MEMLIMIT=0M
//SYSUT2 DD DISP=SHR,
//          DSN=${instance-EKMF_ZOS_STCJOBS}(${instance-EKMF_WEB_STC})
//SYSPRINT DD SYSOUT=*
//SYSIN  DD *
//SYSUT1 DD DATA,DLM='@@'
#set($jobcard = "//${instance-EKMF_WEB_STC} ")
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
//EKMF    EXEC ${instance-EKMF_WEB_STC}
@@
/*
#end