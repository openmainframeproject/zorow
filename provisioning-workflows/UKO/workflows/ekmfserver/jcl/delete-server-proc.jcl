//**********************************************************************/
//* Copyright Contributors to the zOS-Workflow Project.                */
//* SPDX-License-Identifier: Apache-2.0                                */
//**********************************************************************/
//STEP1       EXEC  PGM=IKJEFT1A,DYNAMNBR=20
//SYSTSPRT    DD    SYSOUT=A
//SYSTSIN     DD    *
 ALLOCATE FILE(DD1) DATASET('${instance-EKMF_ZOS_PROCLIB}') SHR
 DELETE '${instance-EKMF_ZOS_PROCLIB}(${instance-EKMF_WEB_STC})' FILE(DD1)
 FREE FILE(DD1)
#if(${instance-EKMF_STC_JOB_CARD} && $!{instance-EKMF_STC_JOB_CARD} != "")
#if(${instance-EKMF_ZOS_STCJOBS} && $!{instance-EKMF_ZOS_STCJOBS} != "")
 ALLOCATE FILE(DD2) DATASET('${instance-EKMF_ZOS_STCJOBS}') SHR
 DELETE '${instance-EKMF_ZOS_STCJOBS}(${instance-EKMF_WEB_STC})' FILE(DD2)
 FREE FILE(DD2)
#end
#end
/*