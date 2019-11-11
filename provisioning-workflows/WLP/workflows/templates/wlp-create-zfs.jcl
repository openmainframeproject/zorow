//*******************************************************                      
//* Allocate new zfs                      
//*******************************************************                      
//ALLOC    EXEC   PGM=IDCAMS                      
//SYSPRINT DD     SYSOUT=*                      
//SYSUDUMP DD     SYSOUT=*                      
//AMSDUMP  DD     SYSOUT=*                      
//DASD0    DD     DISP=OLD,UNIT=3390,VOL=SER=${instance-VOLUME}        
//SYSIN    DD     *                                       
     DEFINE CLUSTER (NAME( -                      
            ${instance-FILE_SYSTEM_HLQ}.${_workflow-softwareServiceInstanceName}) -                  
            VOLUMES(${instance-VOLUME}) -        
            LINEAR CYL(${instance-PRIMARY_CYLINDERS} ${instance-SECONDARY_CYLINDERS}) -    
            SHAREOPTIONS(3))                      
/*                      
//*******************************************************                      
//* Format new zfs                      
//*******************************************************                      
//CREATE   EXEC   PGM=IOEAGFMT,REGION=0M,                      
// PARM=('-aggregate ${instance-FILE_SYSTEM_HLQ}.${_workflow-softwareServiceInstanceName} -compat')                  
//SYSPRINT DD     SYSOUT=*                      
//STDOUT   DD     SYSOUT=*                      
//STDERR   DD     SYSOUT=*                      
//SYSUDUMP DD     SYSOUT=*                      
//CEEDUMP  DD     SYSOUT=*                      
//*******************************************************                      
//* Mount new zfs                      
//*******************************************************                      
//MOUNTZFS EXEC PGM=IKJEFT1A,DYNAMNBR=20                    
//SYSTSPRT DD  SYSOUT=*                      
//SYSTSIN  DD  *                          
 MOUNT FILESYSTEM('${instance-FILE_SYSTEM_HLQ}.${_workflow-softwareServiceInstanceName}') -                  
   MOUNTPOINT('${instance-WLP_USER_DIR}') TYPE(ZFS)  
#if(${instance-GROUP_NAME} != "" && ${instance-GROUP_NAME})   
 BPXBATCH SH chmod 770 ${instance-WLP_USER_DIR}  
 BPXBATCH SH chown ${instance-WLP_USER}:${instance-GROUP_NAME} ${instance-WLP_USER_DIR} 
#else
 BPXBATCH SH chmod 700 ${instance-WLP_USER_DIR}
 BPXBATCH SH chown ${instance-WLP_USER} ${instance-WLP_USER_DIR}
#end     
/*        