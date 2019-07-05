//BIPCHBK  EXEC PGM=IKJEFT1A,REGION=0M           
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
mqsichangebroker -                               
  ${instance-IIB_BROKER_NAME} -                                       
  -s inactive                                      
/*                                               

