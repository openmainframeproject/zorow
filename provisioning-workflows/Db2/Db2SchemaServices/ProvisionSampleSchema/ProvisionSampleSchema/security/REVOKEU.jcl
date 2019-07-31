//REVOKEU EXEC PGM=IKJEFT01,DYNAMNBR=20,COND=(4,LT)
//STEPLIB  DD DSN=${instance-DSNLOAD},DISP=SHR
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
  DSN SYSTEM(${instance-MVSSNAME})
  RUN  PROGRAM(${instance-PROGNAME}) PLAN(${instance-PLANNAME}) -
       LIB('${instance-RUNLIB}')
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
 SET CURRENT SQLID='${instance-SQLID}';
  REVOKE USE OF TABLESPACE ${instance-DBASEA}.
        ${instance-TSPREFIX}D
        FROM ${instance-USERNAME};
  REVOKE USE OF TABLESPACE ${instance-DBASEA}.
        ${instance-TSPREFIX}E
        FROM ${instance-USERNAME};
  REVOKE USE OF TABLESPACE ${instance-DBASEA}.
        ${instance-TSPREFIX}P
        FROM ${instance-USERNAME};
  REVOKE USE OF TABLESPACE ${instance-DBASEA}.
        ${instance-TSPREFIX}S
        FROM ${instance-USERNAME};
  REVOKE USE OF TABLESPACE ${instance-DBASEP}.
        ${instance-TSPREFIX}C
        FROM ${instance-USERNAME};
  REVOKE USE OF TABLESPACE ${instance-DBASEP}.
        ${instance-TSPREFIX}Q
        FROM ${instance-USERNAME};
  REVOKE USE OF TABLESPACE ${instance-DBASEX}.
        ${instance-TSPREFIX}X
        FROM ${instance-USERNAME};
 REVOKE DBADM ON DATABASE ${instance-DBASEA}
  FROM ${instance-USERNAME};
 REVOKE DBADM ON DATABASE ${instance-DBASEP}
  FROM ${instance-USERNAME};
 REVOKE USE OF BUFFERPOOL ${instance-BP} FROM ${instance-USERNAME};
 REVOKE USE OF STOGROUP ${instance-STOGROUP} FROM ${instance-USERNAME};
 COMMIT;
