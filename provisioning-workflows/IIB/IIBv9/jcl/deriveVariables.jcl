//******************************************************************
//* Copyright Contributors to the zOS-Workflow Project.            *
//* PDX-License-Identifier: Apache-2.0                             *
//******************************************************************
//GENER   EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
 GENERATE
 LABELS DATA=ALL
/*
//SYSUT1  DD *
 /* Rexx */
 l = 'abcdefghijklmnopqrstuvwxyz'
 u = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

 lpar = substr("${_workflow-workflowSystem}",1,4)
 phase = substr("${instance-IIB_ENVIRONMENT}",1,1)
 select
 when phase = "X" then do
            db2subsys = "DBXC"
            db2port = 10446
          end
 when phase = "O" then do
            db2subsys = "DBOF"
            db2port = 16446
          end
 when phase = "T" then do
            db2subsys = "DBTF"
            db2port = 17446
          end
 when phase = "A" then do
            db2subsys = "DBFZ"
            db2port = 10447
           end
 when phase = "F" then do
            db2subsys = "DBFF"
            db2port = 1446
          end
 when phase = "P" then do
            db2subsys = "DBEF"
            db2port = 1446
          end
 otherwise do
            db2subsys = "UNKNOWN"
            db2port = "ERROR"
            Say "DB2 subsystem for environment could not be determined"
            Exit 999
          end
 end
additional = ${instance-ADDITIONAL_MEMBER}
if additional = "NONE"
then sysplexha = "NO"
else sysplexha = "YES"

 brokername = "IB${instance-IIB_ENVIRONMENT}"substr(lpar,4,1)"${instance-IIB_BROKER_SEQ}"
 brokernamelc = translate(brokername,l,u)


 data.1 = "IIB_STCUSER = "brokername"U"
 data.2 = "IIB_TIV_USER_LC = ${instance-IIB_TIV_USER.toLowerCase()}"
 data.3 = "IIB_HOME_DIR = /u/miscuser/"brokernamelc"u"
 data.4 = "IIB_WORK_DIR = /var/mqsi/brokers/"brokernamelc
 data.5 = "IIB_RUNASUSER = "brokername"U"
 data.6 = "IIB_EXG_NAMEBASE = IM${instance-IIB_ENVIRONMENT}"substr(lpar,length(lpar),1)"${instance-IIB_BROKER_SEQ}0"
 data.7 = "IIB_DSNAOINI = BIPDSN${instance-IIB_ENVIRONMENT}"
 data.8 = "IIB_CURRENTSQLID = T5${instance-IIB_ENVIRONMENT}DBA"
 data.9 = "IIB_BROKER_NAME = "brokername
 data.10 = "IIB_BROKER_NAME_LC = "brokernamelc
 data.11 = "IIB_WORK_DIR_SYMLINK = /var/mqsi/brokers/"brokernamelc
 data.12 = "IIB_ODBC_HOME_DIR = /u/miscuser/${instance-IIB_XDBC_USER.toLowerCase()}"
 data.13 = "IIB_WAS_HOME_DIR = /u/miscuser/${instance-IIB_WAS_USER.toLowerCase()}"
 data.14 = "IIB_PLEX = "substr(lpar,1,3)
 data.15 = "IIB_DB2_DS_SUBSYS_PREFIX = ${instance-IIB_DB2_DS_PREFIX}."db2subsys
 data.16 = "IIB_LPAR_NAME = "lpar
 data.17 = "IIB_DBSRV_NAME = "db2subsys
 data.18 = "IIB_JDBC_PORTNR = "db2port
 data.19 = "RABO_INSTANCEID = "brokername
 data.20 = "RABO_SYSPLEXHA = "sysplexha

 data.0 = 20

 ADDRESS SYSCALL "WRITEFILE $_output 777 data."
 rcw = rc
 sleep 2

 Exit rcw
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
