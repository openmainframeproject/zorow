//**********************************************************************/
//* Copyright Contributors to the zOS-Workflow Project.                */
//* SPDX-License-Identifier: Apache-2.0                                */
//**********************************************************************/
//COPYPARM EXEC PGM=IKJEFT01
//IN DD PATH='${instance-TEMP_DIR}/${instance-EKMF_AGENT_STC}-KMGPARM'
//OUT DD DISP=SHR,DSN=${instance-EKMF_ZOS_PARMLIB}(${instance-EKMF_AGENT_STC})
//SYSTSPRT DD SYSOUT=*
//SYSTSIN DD *
OCOPY INDD(IN) OUTDD(OUT) TEXT
/*