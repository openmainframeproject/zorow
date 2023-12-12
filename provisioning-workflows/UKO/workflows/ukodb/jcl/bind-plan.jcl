//**********************************************************************/
//* Copyright Contributors to the zOS-Workflow Project.                */
//* SPDX-License-Identifier: Apache-2.0                                */
//**********************************************************************/
//*********************************************************************
//* EXPECT COND CODE 8 FROM STEP BINDPLAN WHEN THIS JOB RUNS FOR THE
//* FIRST TIME, AND THE 'REVOKE' SQL STATEMENT FAIL AS THERE IS NO
//* AUTHORITY TO REVOKE.
//*********************************************************************
//BINDPLAN EXEC PGM=IKJEFT01,REGION=4096K
// EXPORT SYMLIST=*
// SET DBSCHEMA=${instance-DB_CURRENT_SCHEMA}
// SET DBPACK=${instance-DB_AGENT_PACKAGE}
// SET DBPLAN=${instance-DB_AGENT_PLAN}
//STEPLIB   DD DISP=SHR,DSN=${instance-DB2_HLQ}.SDSNLOAD
//SYSTSPRT  DD SYSOUT=*,DCB=BLKSIZE=121
//SYSPRINT  DD SYSOUT=*
//SYSUDUMP  DD SYSOUT=*
//SYSIN     DD *,SYMBOLS=(JCLONLY)
 SET CURRENT SQLID = '&DBSCHEMA' ;
*- ENSURE STARTED TASK USER HAVE ACCESS TO THE DB2 PLAN/PACKAGE
*- CHANGE BELOW TO REFLECT YOUR STARTED TASK USER (ID OR GROUP)
*- REVOKE EXECUTE ON PLAN &DBPLAN FROM
*-               ${instance-UKO_AGENT_STC_USER};
GRANT EXECUTE ON PLAN &DBPLAN TO
              ${instance-UKO_AGENT_STC_USER};
//SYSTSIN   DD *,SYMBOLS=(JCLONLY)
  DSN SYSTEM(${instance-DB2_JCC_SSID})
   BIND PLAN(&DBPLAN)      -
    PKLIST(&DBPACK..KMGPTRAN -
           &DBPACK..KMGP0004 -
           &DBPACK..KMGP0005 -
           &DBPACK..KMGP0203 -
           &DBPACK..KMGP0205 -
           &DBPACK..KMGP0206 -
           &DBPACK..KMGP0207 -
           &DBPACK..KMGP0208 -
           &DBPACK..KMGP0209 -
           &DBPACK..KMGP0210 -
           &DBPACK..KMGP0211 -
           &DBPACK..KMGP0213 -
           &DBPACK..KMGP0215 -
           &DBPACK..KMGP0216 -
           &DBPACK..KMGP0217 -
           &DBPACK..KMGP0300) -
    ACTION(REP) RETAIN    -
    VALIDATE(BIND)     -
    ENCODING(EBCDIC) -
    DYNAMICRULES(BIND) -
    KEEPDYNAMIC(NO) -
    OWNER(&DBSCHEMA) EXPLAIN(NO) -
    ISOLATION(CS)
   RUN PROGRAM(${instance-DB_PROGRAM}) PLAN(${instance-DB_PLAN}) LIB('${instance-DB2_RUNLIB}')
  END