//******************************************************************
//* Copyright Contributors to the zOS-Workflow Project.            *
//* PDX-License-Identifier: Apache-2.0                             *
//******************************************************************
//******************************************************************
//*              IBM Integration Bus                               *
//*                                                                *
//* Sample job to create an Integration node (mqsicreatebroker).   *
//*                                                                *
//******************************************************************
//* Run mqsicreatebroker command
//******************************************************************
//*
//BIPCRBK  EXEC PGM=IKJEFT1A,REGION=0M
//*        MQSeries Runtime Libraries
//STEPLIB  DD DISP=SHR,DSN=${instance-IIB_MQ_DS_PREFIX}.SCSQANLE
//         DD DISP=SHR,DSN=${instance-IIB_MQ_DS_PREFIX}.SCSQAUTH
//         DD DISP=SHR,DSN=${instance-IIB_MQ_DS_PREFIX}.SCSQLOAD
//STDENV   DD PATHOPTS=(ORDONLY),
//            PATH='${instance-IIB_HOME_DIR}/ENVFILE'
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
BPXBATSL PGM -
  ${instance-IIB_USS_BIN}/-
mqsicreatebroker -
  ${instance-IIB_BROKER_NAME} -
  -q ${instance-IIB_QMGR_NAME} -
  -2
/*
//
