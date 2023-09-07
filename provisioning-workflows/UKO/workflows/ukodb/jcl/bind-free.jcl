//**********************************************************************/
//* Copyright Contributors to the zOS-Workflow Project.                */
//* SPDX-License-Identifier: Apache-2.0                                */
//**********************************************************************/
//*
//BINDPLAN EXEC PGM=IKJEFT01,REGION=4096K
// EXPORT SYMLIST=*
// SET DBPACK=${instance-DB_AGENT_PACKAGE}
// SET DBPLAN=${instance-DB_AGENT_PLAN}
//STEPLIB   DD DISP=SHR,DSN=${instance-DB2_HLQ}.SDSNLOAD
//SYSTSPRT  DD SYSOUT=*,DCB=BLKSIZE=121
//SYSPRINT  DD SYSOUT=*
//SYSUDUMP  DD SYSOUT=*
//SYSTSIN   DD *,SYMBOLS=(JCLONLY)
  DSN SYSTEM(DL3N)
   FREE                     -
   PACKAGE(&DBPACK..KMGPTRAN.(*) -
           &DBPACK..KMGP0004.(*) -
           &DBPACK..KMGP0005.(*) -
           &DBPACK..KMGP0203.(*) -
           &DBPACK..KMGP0205.(*) -
           &DBPACK..KMGP0206.(*) -
           &DBPACK..KMGP0207.(*) -
           &DBPACK..KMGP0208.(*) -
           &DBPACK..KMGP0209.(*) -
           &DBPACK..KMGP0210.(*) -
           &DBPACK..KMGP0211.(*) -
           &DBPACK..KMGP0213.(*) -
           &DBPACK..KMGP0215.(*) -
           &DBPACK..KMGP0216.(*) -
           &DBPACK..KMGP0217.(*) -
           &DBPACK..KMGP0300.(*) )
   FREE PLAN(&DBPLAN)
  END