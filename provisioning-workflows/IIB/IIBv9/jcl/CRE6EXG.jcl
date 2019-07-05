//******************************************************************
//*              IBM Integration Bus                               *
//*                                                                *
//* Sample job to create integration servers                       *
//* (mqsicreateexecutiongroup)                                     *
//*                                                                *
//******************************************************************
//* Run mqsicreateexecutiongroup command
//******************************************************************
//*
//BIPCREG  EXEC PGM=IKJEFT01
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
mqsicreateexecutiongroup -
  ${instance-IIB_BROKER_NAME} -
  -e ${instance-IIB_EXG_NAMEBASE}1
BPXBATSL PGM -
  ${instance-IIB_USS_BIN}/-
mqsicreateexecutiongroup -
  ${instance-IIB_BROKER_NAME} -
  -e ${instance-IIB_EXG_NAMEBASE}2
/*
//