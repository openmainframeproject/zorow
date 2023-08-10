//**********************************************************************/
//* Copyright Contributors to the zOS-Workflow Project.                */
//* SPDX-License-Identifier: Apache-2.0                                */
//**********************************************************************/
//*******************************************************
//* delete SQL
//*******************************************************
//DELSQL  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE  '${instance-DB2_TEMP_HLQ}.SQL'
  SET MAXCC = 00
//*
//*******************************************************
//* delete database
//*******************************************************
//EKMFSQL  EXEC PGM=IKJEFT01,REGION=0M               
//STEPLIB  DD DISP=SHR,DSN=${instance-DB2_HLQ}.SDSNLOAD               
//SYSTSPRT DD SYSOUT=*,DCB=BLKSIZE=131                         
//SYSPRINT DD SYSOUT=*                                         
//SYSUDUMP DD SYSOUT=*                                         
//SYSTSIN  DD *                                                
 DSN SYSTEM(${instance-DB2_JCC_SSID})                                              
 RUN PROGRAM(${instance-DB_PROGRAM}) PLAN(${instance-DB_PLAN}) LIB('${instance-DB2_RUNLIB}') 
 END                                                           
//SYSIN     DD    *                                            
SET CURRENT SQLID = '${instance-EKMF_ADMIN_DB}';   

DROP DATABASE ${instance-EKMF_API_DB_NAME} ;

DROP DATABASE ${instance-DATA_SET_DB_NAME} ;

COMMIT;                                                

/*