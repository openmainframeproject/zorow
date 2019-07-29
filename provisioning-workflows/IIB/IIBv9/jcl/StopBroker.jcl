//******************************************************************
//*                                                                *
//* Stop the IIB Broker                                            *
//*                                                                *
//* Must be run on a jobclass with the COMMAND=EXECUTE attribute.  *
//*                                                                *
//******************************************************************
//STOPIIB EXEC PGM=IEFBR14
//SYSPRINT DD SYSOUT=*    
//   COMMAND 'P ${instance-IIB-BROKER-NAME}' 
