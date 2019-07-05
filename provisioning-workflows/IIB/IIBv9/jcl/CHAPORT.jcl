//******************************************************************
//*              IBM Integration Bus                               *
//*                                                                *
//* Sample job to change properties (mqsichangeproperties).        *
//*                                                                *
//******************************************************************
//* Run mqsichangeproperties command
//******************************************************************
//*
//BIPCHPR  EXEC PGM=IKJEFT1A,REGION=0M
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
mqsichangeproperties -
  ${instance-IIB_BROKER_NAME} -
  -b webadmin -
  -o HTTPConnector -
  -n port -
  -v ${instance-IIB_BROKER_PORT}
/*
//