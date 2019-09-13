//***************************************************************** 
//* Create ENVFILE from BIPPROF       
//***************************************************************** 
//*                                                                 
//CREATENV EXEC PGM=IKJEFT1B,REGION=0M                              
//STDOUT  DD SYSOUT=*                                               
//STDERR  DD SYSOUT=*                                               
//SYSTSPRT DD SYSOUT=*                                              
//SYSTSIN  DD *                                                     
  BPXBATCH SH -                                                     
  . ${instance-IIB_HOME_DIR}/bipprof; -                             
  /bin/printenv > -                                                 
  ${instance-IIB_HOME_DIR}/ENVFILE 
/*