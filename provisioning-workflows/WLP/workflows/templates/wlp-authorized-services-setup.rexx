/* Rexx */
trace commands
address tso

/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/
/* ------------------------------------------------------------------------- */
/* This rexx file contains the TSO commands to allow the server to start as  */
/* a started task (if configured to do so) and to grant the server access to */
/* z/OS authorized services. This file is RACF specific, but can be edited   */
/* to fit the syntax of other security vendors. Additionally, commands can   */
/* be added or removed depending on the level of access desired.             */
/* ------------------------------------------------------------------------- */

#if(${instance-WLP_CREATE_ZFS} == "TRUE" && ${instance-GROUP_NAME} != "" && ${instance-GROUP_NAME})
   #set ($idField = ${instance-GROUP_NAME})
#else
   #set ($idField = ${instance-WLP_USER})
#end

/* Create a started profile for the proc if we are starting as a started task */
#if(${instance-START_SERVER_AS_STARTED_TASK} == "TRUE")
#if(${instance-ENABLE_WLP_GROUP_ACCESS} == "TRUE")
"RDEF STARTED ${_workflow-softwareServiceInstanceName}.* UACC(NONE) STDATA(USER(${instance-WLP_USER}) group(${instance-GROUP_NAME}) PRIVILEGED(NO) TRUSTED(NO) TRACE(YES))"
#else
"RDEF STARTED ${_workflow-softwareServiceInstanceName}.* UACC(NONE) STDATA(USER(${instance-WLP_USER}) PRIVILEGED(NO) TRUSTED(NO) TRACE(YES))"
#end
#end

/* Grant the server access to the angel process */
"RDEF SERVER bbg.angel UACC(NONE)"
"PERMIT bbg.angel CLASS(SERVER) ACCESS(READ) ID(${idField})"
IF RC<>0 then exit 8

/* Enable the server to use the z/OS Authorized services */
"RDEF SERVER bbg.authmod.bbgzsafm UACC(NONE)"
"PERMIT bbg.authmod.bbgzsafm CLASS(SERVER) ACCESS(READ) ID(${idField})"
IF RC<>0 then exit 8

/* Enable the SAF authorized user registry services and SAF authorization services */
"RDEF SERVER bbg.authmod.bbgzsafm.safcred UACC(NONE)"
"PERMIT bbg.authmod.bbgzsafm.safcred CLASS(SERVER) ACCESS(READ) ID(${idField})"
IF RC<>0 then exit 8

/* Enable the SVCDUMP services */
"RDEF SERVER bbg.authmod.bbgzsafm.zosdump UACC(NONE)"
"PERMIT bbg.authmod.bbgzsafm.zosdump CLASS(SERVER) ACCESS(READ) ID(${idField})"
IF RC<>0 then exit 8

/* If binding to a DB2 subsystem, enable the RRS transaction services */
#if(${instance-DB2_REGISTRY_NAME} != "" && ${instance-DB2_REGISTRY_NAME})
"RDEF SERVER bbg.authmod.bbgzsafm.txrrs UACC(NONE)"
"PERMIT bbg.authmod.bbgzsafm.txrrs CLASS(SERVER) ACCESS(READ) ID(${idField})"
IF RC<>0 then exit 8
#end

/* Grant access to bpx.jobname to allow the _BPX_JOBNAME variable to be set in the server.env */
"RDEFINE FACILITY bpx.jobname UACC(NONE)"
"PERMIT bpx.jobname CLASS(FACILITY) ACCESS(READ) ID(${idField})"
IF RC<>0 then exit 8


/* --------------------------------------------- */
/* Configure a security domain for server auth   */
/* --------------------------------------------- */

/* Define the server specific APPLID to RACF */
"RDEFINE APPL ${_workflow-softwareServiceInstanceName} UACC(NONE)"

/* Activate the APPL class */
/* If not active, the domain is not restricted, which means anyone can authenticate to it */
"SETROPTS CLASSACT(APPL)"

/* Grant the user or group read access to the APPLID */
"PERMIT ${_workflow-softwareServiceInstanceName} CLASS(APPL) ACCESS(READ) ID(${idField})"

/* Grant an unauthenticated user ID READ access to the APPLID in the APPL class  */
"PERMIT ${_workflow-softwareServiceInstanceName} CLASS(APPL) ACCESS(READ) ID(${instance-UNAUTH_USER})"

/* Create the domain and permit the user or group to it */
"RDEFINE SERVER BBG.SECPFX.${_workflow-softwareServiceInstanceName} UACC(NONE)"
"PERMIT BBG.SECPFX.${_workflow-softwareServiceInstanceName} CLASS(SERVER) ACCESS(READ) ID(${idField})"

/* Create an EJBROLE profile for this server to force authentication for any applications deployed to this server */
/* This command can be altered depending on the level of security desired */
"RDEF EJBROLE ${_workflow-softwareServiceInstanceName}.*.* UACC(NONE)"
"PERMIT ${_workflow-softwareServiceInstanceName}.*.* CLASS(EJBROLE) ACCESS(READ) ID(${idField})"

/* Refresh */
"SETROPTS RACLIST(FACILITY) REFRESH"
"SETROPTS RACLIST(APPL) REFRESH"
"SETROPTS RACLIST(EJBROLE) REFRESH"
"SETROPTS RACLIST(SERVER) GENERIC(SERVER) REFRESH"
"SETROPTS RACLIST(STARTED) REFRESH"
exit
