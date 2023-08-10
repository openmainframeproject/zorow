//**********************************************************************/
//* Copyright Contributors to the zOS-Workflow Project.                */
//* SPDX-License-Identifier: Apache-2.0                                */
//**********************************************************************/
//DELETE    EXEC PGM=IDCAMS,REGION=1M
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 DELETE ${instance-DB2_TEMP_HLQ}.LOADCONF
 IF MAXCC EQ 8 THEN DO
   SET MAXCC = 0
   END
/*
//ALLOCDDL EXEC PGM=IEFBR14
//DDLWORK  DD DSN=${instance-DB2_TEMP_HLQ}.LOADCONF,
//            DISP=(NEW,CATLG),
//            UNIT=SYSALLDA,
//            DCB=(RECFM=FB,DSORG=PS,LRECL=80),
//            SPACE=(TRK,(1,1),RLSE)
/*
//COPYPARM EXEC PGM=IKJEFT01
//IN DD PATH='${instance-TEMP_DIR}/zosmf-${_workflow-workflowKey}-load'
//OUT DD DISP=SHR,DSN=${instance-DB2_TEMP_HLQ}.LOADCONF
//SYSTSPRT DD SYSOUT=*
//SYSTSIN DD *
OCOPY INDD(IN) OUTDD(OUT) TEXT
/*