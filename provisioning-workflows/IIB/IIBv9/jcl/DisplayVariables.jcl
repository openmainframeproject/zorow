//GENER   EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN DD * 
 GENERATE
 LABELS DATA=ALL
/*
//SYSUT1  DD *
 /* Rexx */
 Say  "IIB_STCUSER = ${instance-IIB_STCUSER}"
 Say  "IIB_TIV_USER_LC = ${instance-IIB_TIV_USER_LC}"
 Say  "IIB_HOME_DIR = ${instance-IIB_HOME_DIR}"
 Say  "IIB_WORK_DIR = ${instance-IIB_WORK_DIR}"
 Say  "IIB_RUNASUSER = ${instance-IIB_RUNASUSER}"
 Say  "IIB_EXG_NAMEBASE = ${instance-IIB_EXG_NAMEBASE}"
 Say  "IIB_DSNAOINI = ${instance-IIB_DSNAOINI}"
 Say  "IIB_CURRENTSQLID = ${instance-IIB_CURRENTSQLID}"
 Say  "IIB_BROKER_NAME_LC = ${instance-IIB_BROKER_NAME_LC}"
 Say  "IIB_WORK_DIR = ${instance-IIB_WORK_DIR}"
 Say  "IIB_ODBC_HOME_DIR = ${instance-IIB_WORK_DIR}"
 Say "IIB_XDBC_USER = ${instance-IIB_XDBC_USER}"
 Say "IIB_WAS_USER = ${instance-IIB_WAS_USER} "
 Say "IIB_WASUSER_UID = ${instance-IIB_WASUSER_UID} "
 Say  "_workflow-tenantID = ${_workflow-tenantID}"
 Say "_workflow-domainID = ${_workflow-domainID}" 
 Say "_workflow-templateName = ${_workflow-templateName}"

 Say "Rexx ran ok"
 Exit 0
/*
//SYSUT2  DD  DSNAME=&&DS1(CMD),DISP=(NEW,PASS),
//       UNIT=SYSDA,SPACE=(TRK,(5,,2))
//*
//RDWRJ    EXEC PGM=IKJEFT01
//SYSPRINT DD SYSOUT=*
//SYSPROC  DD DISP=SHR,DSN=&&DS1
//SYSTSPRT DD SYSOUT=*
//SYSTSIN DD *
 CMD
/*
//