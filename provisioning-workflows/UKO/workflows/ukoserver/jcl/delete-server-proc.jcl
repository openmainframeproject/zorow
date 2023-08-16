//**********************************************************************/
//* Copyright Contributors to the zOS-Workflow Project.                */
//* SPDX-License-Identifier: Apache-2.0                                */
//**********************************************************************/
//STEP1       EXEC  PGM=IKJEFT1A,DYNAMNBR=20
//SYSTSPRT    DD    SYSOUT=A
//SYSTSIN     DD    *
 ALLOCATE FILE(DD1) DATASET('${instance-UKO_ZOS_PROCLIB}') SHR
 DELETE '${instance-UKO_ZOS_PROCLIB}(${instance-UKO_SERVER_STC_NAME})' FILE(DD1)
 FREE FILE(DD1)
#if(${instance-UKO_STC_JOB_CARD} && $!{instance-UKO_STC_JOB_CARD} != "")
#if(${instance-UKO_ZOS_STCJOBS} && $!{instance-UKO_ZOS_STCJOBS} != "")
 ALLOCATE FILE(DD2) DATASET('${instance-UKO_ZOS_STCJOBS}') SHR
 DELETE '${instance-UKO_ZOS_STCJOBS}(${instance-UKO_SERVER_STC_NAME})' FILE(DD2)
 FREE FILE(DD2)
#end
#end
/*