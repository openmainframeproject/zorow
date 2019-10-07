/* Rexx */                                                                    
trace commands                                                                                                              
address tso

/* ------------------------------------------------------------------------- */
/* This rexx file contains the TSO commands to remove RACF profiles defined  */
/* by this workflow.                                                         */
/* ------------------------------------------------------------------------- */

#if(${instance-WLP_CREATE_ZFS} == "TRUE" && ${instance-GROUP_NAME} != "" && ${instance-GROUP_NAME})
   #set ($idField = ${instance-GROUP_NAME})
#else
   #set ($idField = ${instance-WLP_USER})
#end

#if(${instance-START_SERVER_AS_STARTED_TASK} == "TRUE")
"PERMIT ${_workflow-softwareServiceInstanceName}.* CLASS(STARTED) ID(${idField}) DELETE"
"RDELETE STARTED ${_workflow-softwareServiceInstanceName}.*"
#end

"PERMIT ${_workflow-softwareServiceInstanceName}.* CLASS(APPL) ID(${idField}) DELETE"
"RDELETE APPL ${_workflow-softwareServiceInstanceName}"

"PERMIT ${_workflow-softwareServiceInstanceName}.* CLASS(SERVER) ID(${idField}) DELETE"
"RDELETE SERVER BBG.SECPFX.${_workflow-softwareServiceInstanceName}"

"PERMIT ${_workflow-softwareServiceInstanceName}.* CLASS(EJBROLE) ID(${idField}) DELETE"
"RDELETE EJBROLE ${_workflow-softwareServiceInstanceName}.*.*"

"SETROPTS RACLIST(APPL) REFRESH"
"SETROPTS RACLIST(EJBROLE) REFRESH"
"SETROPTS RACLIST(SERVER) GENERIC(SERVER) REFRESH"
"SETROPTS RACLIST(STARTED) REFRESH"
exit