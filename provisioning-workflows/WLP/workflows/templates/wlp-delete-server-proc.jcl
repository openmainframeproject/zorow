//*******************************************************                      
//* Delete the proc                     
//*******************************************************  
//DEALLOC   EXEC PGM=IDCAMS
//SYSPRINT DD   SYSOUT=*
//DD1   DD DISP=SHR,DSN=${instance-PROCLIB}
 DELETE '${instance-PROCLIB}(${_workflow-softwareServiceInstanceName})' FILE(DD1)
 IF LASTCC = 8 THEN DO
  SET MAXCC = 0
  END 
/*