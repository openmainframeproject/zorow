//${instance-IIB_BROKER_NAME} PROC COMPK='${instance-IIB_BROKER_NAME}',
//         INSTP='/usr/lpp/mqsi/V9R0M0',
//         MAINP='bipimain',
//         SRVMP='bipservice',
//         COMDS='${instance-ZOSMF_PARMLIB}',
//         STRTP='AUTO',
//*        COMPDIR='${instance-IIB_WORK_DIR}',
//         SE='',
//         SH='',
//         HOME='${instance-IIB_HOME_DIR}',
//         E='',
//         DB2HLQ='${instance-IIB_DB2_DS_PREFIX}.${instance-IIB_DBSRV_NAME}',
//         WMQHLQ='${instance-IIB_MQ_DS_PREFIX}'
//*
//*
//* *****************************************************************
//* Test to see if the ENVFILE exists.
//* The base ENVFILE called ENVFILE should exist.
//* Integration server specific ENVFILEs (ENVFILE.<EGLabel>) may
//* exist if specified. If not then use the base ENVFILE.
//* Should return RC=0 if an integration server specific ENVFILE
//* exists, otherwise RC=256 (use the base ENVFILE).
//* ****************************************************************
//*
//CHECKENV EXEC PGM=BPXBATSL,REGION=0M,TIME=NOLIMIT,
//         PARM='PGM /bin/test -e &HOME./ENVFILE.&E.'
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//*
//* ****************************************************************
//* Copy ENVFILE to SYSOUT
//* ****************************************************************
//*
//         IF (CHECKENV.RC EQ 0) THEN
//COPYENV1 EXEC PGM=IKJEFT01,
//         PARM='OCOPY INDD(BIPFROM) OUTDD(ENVFILE)'
//SYSTSPRT DD DUMMY
//BIPFROM  DD PATHOPTS=(ORDONLY),
//            PATH='&HOME./ENVFILE.&E.'
//ENVFILE  DD SYSOUT=*,DCB=(RECFM=V,LRECL=8192)
//SYSTSIN  DD DUMMY
//         ELSE
//COPYENV2 EXEC PGM=IKJEFT01,
//         PARM='OCOPY INDD(BIPFROM) OUTDD(ENVFILE)'
//SYSTSPRT DD DUMMY
//BIPFROM  DD PATHOPTS=(ORDONLY),
//            PATH='&HOME./ENVFILE'
//ENVFILE  DD SYSOUT=*,DCB=(RECFM=V,LRECL=8192)
//SYSTSIN  DD DUMMY
//         ENDIF
//*
//* ****************************************************************
//* Copy DSNAOINI to SYSOUT
//* ****************************************************************
//*
//COPYDSN  EXEC PGM=IKJEFT01,
//         PARM='OCOPY INDD(BIPFROM) OUTDD(DSNAOINI)'
//SYSTSPRT DD DUMMY
//BIPFROM  DD DISP=SHR,DSN=&COMDS.(${instance-IIB_DSNAOINI})
//DSNAOINI DD SYSOUT=*,DCB=(RECFM=V,LRECL=256)
//SYSTSIN  DD DUMMY
//*
//* ****************************************************************
//* Test to see if starting an integration server address space.
//* Should return RC=0 if starting a Control address space or
//* RC=12 if starting an integration server address space.
//* ****************************************************************
//*
//CHECKDFE EXEC PGM=IKJEFT01,
//         PARM='LISTDS ''&COMDS.&SE.'''
//SYSTSIN  DD DUMMY
//SYSTSPRT DD DUMMY
//*
//         IF (CHECKDFE.RC=0) THEN
//*
//* ****************************************************************
//* Integration node MQ and environment verification
//* ****************************************************************
//*
//VERIFY   EXEC PGM=BPXBATSL,REGION=0M,TIME=NOLIMIT,
//         PARM='PGM &INSTP./bin/mqsicvp ${instance-IIB_BROKER_NAME}'
//*        MQSeries Runtime Libraries
//STEPLIB  DD DSN=&WMQHLQ..SCSQANLE,DISP=SHR
//         DD DSN=&WMQHLQ..SCSQAUTH,DISP=SHR
//         DD DSN=&WMQHLQ..SCSQLOAD,DISP=SHR
//STDENV   DD PATH='&HOME./ENVFILE'
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//*
//* ****************************************************************
//* Step to delete residual locks
//* (this is only needed if the integration node is ARM enabled)
//* ****************************************************************
//*
//*RMLOCKS  EXEC PGM=BPXBATCH,REGION=0M,TIME=NOLIMIT,
//*         PARM='SH rm -f &COMPDIR./common/locks/*'
//*
//         ENDIF
//*
//* ****************************************************************
//* Check RCs from previous steps and call correct program
//* with the correct ENVFILE
//* ****************************************************************
//*
//         IF (CHECKDFE.RC EQ 0) AND (VERIFY.RC EQ 0) THEN
//*
//* ****************************************************************
//* Start Control Address Space with base ENVFILE
//* (bipimain, bipservice and bipbroker)
//* ****************************************************************
//*
//BROKER   EXEC PGM=BPXBATA8,REGION=0M,TIME=NOLIMIT,
//         PARM='PGM &INSTP./bin/&MAINP. &SRVMP. &COMPK. &STRTP.'
//*        MQSeries Runtime Libraries
//STEPLIB  DD DSN=&WMQHLQ..SCSQANLE,DISP=SHR
//         DD DSN=&WMQHLQ..SCSQAUTH,DISP=SHR
//         DD DSN=&WMQHLQ..SCSQLOAD,DISP=SHR
//STDENV   DD PATH='&HOME./ENVFILE'
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//*
//         ELSE
//         IF (CHECKENV.RC EQ 0) AND (CHECKDFE.RC NE 0) THEN
//*
//* ****************************************************************
//* Start an integration server address space with specific ENVFILE
//* (bipimain and DataFlowEngine)
//* ****************************************************************
//*
//EGENV    EXEC PGM=BPXBATA8,REGION=0M,TIME=NOLIMIT,
//         PARM='PGM &INSTP./bin/&MAINP. &SRVMP. &SE. &SH. &COMPK.
//             &STRTP.'
//*        MQSeries Runtime Libraries
//STEPLIB  DD DSN=&WMQHLQ..SCSQANLE,DISP=SHR
//         DD DSN=&WMQHLQ..SCSQAUTH,DISP=SHR
//         DD DSN=&WMQHLQ..SCSQLOAD,DISP=SHR
//*        DB2 Runtime Libraries
//*        Database nodes require DB2 to connect to a datasource.
//*        Note:
//*        DB2 must be included in the STEPLIB if database
//*        nodes are deployed to the Integration node.
//* Also change EGNOENV.
//         DD DISP=SHR,DSN=&DB2HLQ..SDSNEXIT
//         DD DISP=SHR,DSN=&DB2HLQ..SDSNLOAD
//         DD DISP=SHR,DSN=&DB2HLQ..SDSNLOD2
//*        APF Authorized Library of Integration Bus
//*        Required if using Event Notification
//*        (All librarys in concatenation
//*         need to be APF authorized)
//*        DD DISP=SHR,DSN=++WMBHLQ++.SBIPAUTH
//STDENV   DD PATH='&HOME./ENVFILE.&E.'
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//* DD to enable DB2 ODBC trace for each integration server
//*APPLTRC  DD PATHOPTS=(OWRONLY,OCREAT,OAPPEND),
//*            PATHMODE=(SIRWXU,SIRWXG),
//*            PATH='&COMPDIR./output/db2appltrace.&SE..&E.'
//*
//         ELSE
//         IF (CHECKDFE.RC NE 0) THEN
//*
//* ****************************************************************
//* Start an integration server address space with base ENVFILE
//* (bipimain and DataFlowEngine)
//* ****************************************************************
//*
//EGNOENV  EXEC PGM=BPXBATA8,REGION=0M,TIME=NOLIMIT,
//         PARM='PGM &INSTP./bin/&MAINP. &SRVMP. &SE. &SH. &COMPK.
//             &STRTP.'
//*        MQSeries Runtime Libraries
//STEPLIB  DD DSN=&WMQHLQ..SCSQANLE,DISP=SHR
//         DD DSN=&WMQHLQ..SCSQAUTH,DISP=SHR
//         DD DSN=&WMQHLQ..SCSQLOAD,DISP=SHR
//*        DB2 Runtime Libraries
//*        Database nodes require DB2 to connect to a datasource.
//*        Note:
//*        DB2 must be included in the STEPLIB if database
//*        nodes are deployed to the Integration node.
//* Also change EGENV.
//         DD DISP=SHR,DSN=&DB2HLQ..SDSNEXIT
//         DD DISP=SHR,DSN=&DB2HLQ..SDSNLOAD
//         DD DISP=SHR,DSN=&DB2HLQ..SDSNLOD2
//*        APF Authorized Library of Integration Bus
//*        Required if using Event Notification
//*        (All librarys in concatenation
//*         need to be APF authorized)
//*        DD DISP=SHR,DSN=++WMBHLQ++.SBIPAUTH
//STDENV   DD PATH='&HOME./ENVFILE'
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//* DD to enable DB2 ODBC trace for each integration server
//*APPLTRC  DD PATHOPTS=(OWRONLY,OCREAT,OAPPEND),
//*            PATHMODE=(SIRWXU,SIRWXG),
//*            PATH='&COMPDIR./output/db2appltrace.&SE..&E.'
//*
//         ENDIF
//         ENDIF
//         ENDIF
//*
//*-----------------------------------------------------------------
//         PEND
//*-----------------------------------------------------------------
//*
//
