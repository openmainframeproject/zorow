//**********************************************************************/
//* Copyright Contributors to the zOS-Workflow Project.                */
//* SPDX-License-Identifier: Apache-2.0                                */
//**********************************************************************/
//* Create the databases and transfer ownership
//UKODB   EXEC PGM=IKJEFT01,REGION=0M               
//         EXPORT SYMLIST=*
//         SET DBSCHEMA=${instance-DB_CURRENT_SCHEMA}
//STEPLIB  DD DISP=SHR,DSN=${instance-DB2_HLQ}.SDSNLOAD               
//SYSTSPRT DD SYSOUT=*,DCB=BLKSIZE=131                         
//SYSPRINT DD SYSOUT=*                                         
//SYSUDUMP DD SYSOUT=*                                         
//SYSTSIN  DD *                                                
 DSN SYSTEM(${instance-DB2_JCC_SSID})                                              
 RUN PROGRAM(${instance-DB_PROGRAM}) PLAN(${instance-DB_PLAN}) LIB('${instance-DB2_RUNLIB}') 
 END                                                           
//SYSIN     DD    *,SYMBOLS=(JCLONLY)
SET CURRENT SQLID = '${instance-UKO_ADMIN_DB}';   

CREATE DATABASE ${instance-DB_NAME_UKO} STOGROUP ${instance-DB_STOGROUP};          
TRANSFER OWNERSHIP OF DATABASE ${instance-DB_NAME_UKO} 
 TO USER ${instance-DB_CURRENT_SCHEMA} REVOKE PRIVILEGES;                                    

COMMIT;                                                

CREATE DATABASE ${instance-DB_NAME_DATASET_ENCRYPTION_STATUS} STOGROUP ${instance-DB_STOGROUP};          
TRANSFER OWNERSHIP OF DATABASE ${instance-DB_NAME_DATASET_ENCRYPTION_STATUS}  
 TO USER ${instance-DB_CURRENT_SCHEMA} REVOKE PRIVILEGES;                                    

COMMIT;                                                

SET CURRENT SQLID = '${instance-DB_CURRENT_SCHEMA}';  


/*