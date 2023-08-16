//**********************************************************************/
//* Copyright Contributors to the zOS-Workflow Project.                */
//* SPDX-License-Identifier: Apache-2.0                                */
//**********************************************************************/
//* remove the temporary DDL in case the file exists
//DELETE    EXEC PGM=IDCAMS,REGION=1M
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 DELETE ${instance-DB2_TEMP_HLQ}.${instance-DB_CURRENT_SCHEMA}.TEMPDDL
 IF MAXCC EQ 8 THEN DO
   SET MAXCC = 0
   END
/*
//* create the temporary DDL
//ALLOCDDL EXEC PGM=IEFBR14
//DDLWORK  DD DSN=${instance-DB2_TEMP_HLQ}.${instance-DB_CURRENT_SCHEMA}.TEMPDDL,
//            DISP=(NEW,CATLG),
//            UNIT=SYSALLDA,
//            DCB=(RECFM=FB,DSORG=PS,LRECL=80),
//            SPACE=(TRK,(1,1),RLSE)
/*
//* copy the temp ddl from HFS to seq dataset
//COPYPARM EXEC PGM=IKJEFT01
//IN DD PATH='${instance-TEMP_DIR}/zosmf-${_workflow-workflowKey}.ddl'
//OUT DD DISP=SHR,DSN=${instance-DB2_TEMP_HLQ}.${instance-DB_CURRENT_SCHEMA}.TEMPDDL
//SYSTSPRT DD SYSOUT=*
//SYSTSIN DD *
OCOPY INDD(IN) OUTDD(OUT) TEXT
/*
//* Execute the SQL
//UKOSQL  EXEC PGM=IKJEFT01,REGION=0M
//STEPLIB  DD  DISP=SHR,DSN=${instance-DB2_HLQ}.SDSNLOAD
//SYSTSPRT DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSTSIN  DD  *
 DSN SYSTEM(${instance-DB2_JCC_SSID})                                              
 RUN PROGRAM(${instance-DB_PROGRAM}) PLAN(${instance-DB_PLAN}) LIB('${instance-DB2_RUNLIB}') 
  END
//SYSIN    DD DISP=SHR,DSN=${instance-DB2_TEMP_HLQ}.${instance-DB_CURRENT_SCHEMA}.TEMPDDL
/*
//* remove the temporary DDL
//CLEANUP    EXEC PGM=IDCAMS,REGION=1M
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 DELETE ${instance-DB2_TEMP_HLQ}.${instance-DB_CURRENT_SCHEMA}.TEMPDDL
 IF MAXCC EQ 8 THEN DO
   SET MAXCC = 0
   END
/*