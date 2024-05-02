//**********************************************************************/
//* Copyright Contributors to the zOS-Workflow Project.                */
//* SPDX-License-Identifier: Apache-2.0                                */
//**********************************************************************/
//UKODB   EXEC PGM=IKJEFT01,REGION=0M               
//         EXPORT SYMLIST=*
//         SET DBSCHEMA=${instance-DB_CURRENT_SCHEMA}
//STEPLIB  DD DISP=SHR,DSN=${instance-DB2_HLQ}.SDSNLOAD               
//SYSTSPRT DD SYSOUT=*,DCB=BLKSIZE=131                         
//SYSPRINT DD PATHOPTS=(ORDWR,OCREAT),
//   PATHMODE=(SIRWXU,SIRWXG,SIRWXO),
//   PATH='${instance-TEMP_DIR}/zosmf-${_workflow-workflowKey}.version'
//SYSUDUMP DD SYSOUT=*                                         
//SYSTSIN  DD *                                                
 DSN SYSTEM(${instance-DB2_JCC_SSID})                                              
 RUN PROGRAM(${instance-DB_PROGRAM}) PLAN(${instance-DB_PLAN}) LIB('${instance-DB2_RUNLIB}') 
 END                                                           
//SYSIN     DD    *,SYMBOLS=(JCLONLY)
SET CURRENT SQLID = '${instance-DB_CURRENT_SCHEMA}';  
SELECT VERSION
FROM EKMF_META
WHERE VERSION=(SELECT max(VERSION) FROM EKMF_META);

/*