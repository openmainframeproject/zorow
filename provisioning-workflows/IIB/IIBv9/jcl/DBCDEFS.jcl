//******************************************************************
//* Copyright Contributors to the zOS-Workflow Project.            *
//* PDX-License-Identifier: Apache-2.0                             *
//******************************************************************
//******************************************************************
//* Sample JOB to set up FTM JDBC and ODBC connections.            *
//*                                                                *
//******************************************************************
//*                                                                *
//* Run WMB commands for FTM JDBC/ODBC configuration.              *
//*                                                                *
//* MUST RUN UNDER BROKER USERID                                   *
//*                                                                *
//******************************************************************
//FTM#DSNS EXEC PGM=IKJEFT1A
//*TEPLIB  DD DISP=SHR,DSN=${instance-IIB_MQ_DS_PREFIX}.SCSQANLE
//*        DD DISP=SHR,DSN=${instance-IIB_MQ_DS_PREFIX}.SCSQAUTH
//*        DD DISP=SHR,DSN=${instance-IIB_MQ_DS_PREFIX}.SCSQLOAD
//STDENV   DD PATHOPTS=(ORDONLY),
//            PATH='${instance-IIB_HOME_DIR}/ENVFILE'
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
BPXBATSL PGM -
  ${instance-IIB_USS_BIN}/-
mqsireportproperties ${instance-IIB_BROKER_NAME} -
  -o AllReportableEntityNames -
  -c AllTypes -
  -r

BPXBATSL PGM -
  ${instance-IIB_USS_BIN}/-
mqsicreateconfigurableservice ${instance-IIB_BROKER_NAME} -
  -c JDBCProviders -
  -o FTMJDBCProvider -
  -n connectionUrlFormat -
  -v "jdbc:db2://[serverName]:[portNumber]/[databaseName]:/-
user=[user];password=[password];"

BPXBATSL PGM -
  ${instance-IIB_USS_BIN}/-
mqsichangeproperties ${instance-IIB_BROKER_NAME} -
  -c JDBCProviders -
  -o FTMJDBCProvider -
  -n description -
  -v "FTM_DB2_Database_(JDBC)"

BPXBATSL PGM -
  ${instance-IIB_USS_BIN}/-
mqsichangeproperties ${instance-IIB_BROKER_NAME} -
  -c JDBCProviders -
  -o FTMJDBCProvider -
  -n databaseName -
  -v ${instance-IIB_DBSRV_NAME}

BPXBATSL PGM -
  ${instance-IIB_USS_BIN}/-
mqsichangeproperties ${instance-IIB_BROKER_NAME} -
  -c JDBCProviders -
  -o FTMJDBCProvider -
  -n portNumber -
  -v ${instance-IIB_JDBC_PORTNR}

BPXBATSL PGM -
  ${instance-IIB_USS_BIN}/-
mqsichangeproperties ${instance-IIB_BROKER_NAME} -
  -c JDBCProviders -
  -o FTMJDBCProvider -
  -n serverName -
  -v ${instance-IIB_DBSRV_NAME}

BPXBATSL PGM -
  ${instance-IIB_USS_BIN}/-
mqsichangeproperties ${instance-IIB_BROKER_NAME} -
  -c JDBCProviders -
  -o FTMJDBCProvider -
  -n jarsURL -
  -v "${instance-IIB_JDBC_JARS}"

BPXBATSL PGM -
  ${instance-IIB_USS_BIN}/-
mqsichangeproperties ${instance-IIB_BROKER_NAME} -
  -c JDBCProviders -
  -o FTMJDBCProvider -
  -n type4DatasourceClassName -
  -v "com.ibm.db2.jcc.DB2XADataSource"

BPXBATSL PGM -
  ${instance-IIB_USS_BIN}/-
mqsichangeproperties ${instance-IIB_BROKER_NAME} -
  -c JDBCProviders -
  -o FTMJDBCProvider -
  -n type4DriverClassName -
  -v "com.ibm.db2.jcc.DB2Driver"

BPXBATSL PGM -
  ${instance-IIB_USS_BIN}/-
mqsichangeproperties ${instance-IIB_BROKER_NAME} -
  -c JDBCProviders -
  -o FTMJDBCProvider -
  -n securityIdentity -
  -v FTMDB2ID

BPXBATSL PGM -
  ${instance-IIB_USS_BIN}/-
mqsisetdbparms ${instance-IIB_BROKER_NAME} -
  -n jdbc::FTMDB2ID -
  -u ${instance-IIB_xDBC_USER} -
  -p ${instance-IIB_xDBC_PW}

BPXBATSL PGM -
  ${instance-IIB_USS_BIN}/-
mqsisetdbparms ${instance-IIB_BROKER_NAME} -
  -n odbc::${instance-IIB_DBSRV_NAME} -
  -u ${instance-IIB_xDBC_USER} -
  -p ${instance-IIB_xDBC_PW}

BPXBATSL PGM -
  ${instance-IIB_USS_BIN}/-
mqsireportproperties ${instance-IIB_BROKER_NAME} -
  -c AllTypes -
  -o AllReportableEntityNames -
  -r

/*
