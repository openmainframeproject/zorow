/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/

/***********************************************************************/
/* Creating the required user IDs and groups                           */
/***********************************************************************/

AGENT_TASK_USER="${instance-EKMF_AGENT_TASK_USER}"
AGENT_TASK_GROUP="${instance-EKMF_AGENT_TASK_GROUP}"

WEB_CLIENT_USER="${instance-EKMF_CLIENT_USER}"
WEB_CLIENT_GROUP="${instance-EKMF_CLIENT_GROUP}"

WEB_TASK_USER="${instance-EKMF_WEB_TASK_USER}"
WEB_TASK_GROUP="${instance-EKMF_WEB_TASK_GROUP}"

WEB_UNAUTHENTICATED_USER="${instance-EKMF_WEB_UNAUTHENTICATED_USER}"
WEB_UNAUTHENTICATED_GROUP="${instance-EKMF_WEB_UNAUTHENTICATED_GROUP}"

KEY_ADMIN="${instance-EKMF_KEY_ADMIN}"
KEY_ADMIN_GROUP="${instance-EKMF_KEY_ADMIN_GROUP}"

DB_CURRENT_SCHEMA="${instance-DB_CURRENT_SCHEMA}"

KEY_PREFIX="${instance-EKMF_KEY_PREFIX}"
RACF_OWNER="${instance-EKMF_ADMIN_SECURITY}"

#if($!{instance-EKMF_CREATE_GROUPS} == "TRUE" ) 
Say "Creating the required groups"
Say "Creating the Agent started task group"
"ADDGROUP "||AGENT_TASK_GROUP||" SUPGROUP(SYS1) OMVS(AUTOGID)"
Say "Creating the Client group for authentication with the agent"
"ADDGROUP "||WEB_CLIENT_GROUP||" SUPGROUP(SYS1) OMVS(AUTOGID)"
Say "Creating the Liberty started task group"
"ADDGROUP "||WEB_TASK_GROUP||" SUPGROUP(SYS1) OMVS(AUTOGID)"
Say "Creating the unauthenticated user group for the Liberty server"
"ADDGROUP "||WEB_UNAUTHENTICATED_GROUP||" SUPGROUP(SYS1) OMVS(AUTOGID)"
Say "Creating the key administrator group"
"ADDGROUP "||KEY_ADMIN_GROUP||" SUPGROUP(SYS1) OMVS(AUTOGID)"
#end

#if($!{instance-EKMF_CREATE_USERIDS} == "TRUE" ) 
/***********************************************************************/
/* Creating all required user ids                                      */
/***********************************************************************/
/* TODO: we are re-using EKMFSGRP, EKMFUGRP, LIBSRVGP and WSCLGP */
/* temporary group names to fully test RACF setup */
/* or switch to userids instead of groups*/
/* all ICSF access is handled in the groups at the moment*/

Say "Creating the Agent started task user ID and group"
"ADDUSER "||AGENT_TASK_USER||" NOPASSWORD",
   " DFLTGRP("||AGENT_TASK_GROUP||") NAME('EKMF Agent')",
   " OMVS(AUTOUID PROGRAM('/bin/sh')",
   " HOME("||"'"||"/u/"||AGENT_TASK_USER||"'"||"))"

Say "Creating the Client user for authentication with the agent"
"ADDUSER "||WEB_CLIENT_USER||" NOPASSWORD",
   " DFLTGRP("||WEB_CLIENT_GROUP||") NAME('EKMF Client')",
   " OMVS(AUTOUID PROGRAM('/bin/sh')",
   " HOME("||"'"||"/u/"||WEB_CLIENT_USER||"'"||"))"

Say "Creating the Liberty started task user ID and group"
"ADDUSER "||WEB_TASK_USER||" NOPASSWORD",
   " DFLTGRP("||WEB_TASK_GROUP||") NAME('EKMF Liberty SERVER')",
   " OMVS(AUTOUID PROGRAM('/bin/sh')",
   " HOME("||"'"||"/u/"||WEB_TASK_USER||"'"||"))"

Say "Adding the unauthenticated user ID for the Liberty server (WSGUEST by default)"
"ADDUSER "||WEB_UNAUTHENTICATED_USER||" RESTRICTED NOOIDCARD NOPASSWORD",
   " DFLTGRP("||WEB_UNAUTHENTICATED_GROUP||") NAME('WAS DEFAULT USER')",
   " OMVS(AUTOUID PROGRAM('/bin/sh')",
   " HOME("||"'"||"/u/"||WEB_UNAUTHENTICATED_USER||"'"||")) "

Say "Adding the key administrator user"
"ADDUSER "||KEY_ADMIN||" NOOIDCARD ",
   " DFLTGRP("||KEY_ADMIN_GROUP||") NAME('KEY ADMIN')",
   " PHRASE('pass4youpass4you')",
   " TSO( acctnum(DEFAULT) holdclass(H) ",
      "  msgclass(H) sysoutclass(H) proc(ISPFCCC) ",
      "  size(500000) unit(SYSALLDA)) ",
   " OMVS(AUTOUID PROGRAM('/bin/sh')",
   " HOME("||"'"||"/u/"||KEY_ADMIN||"'"||")) "
"PERMIT DEFAULT CL(ACCTNUM ) ACCESS(READ) ID("||KEY_ADMIN||")" 
"PERMIT  * CL(TSOPROC ) ACCESS(READ) ID("||KEY_ADMIN||")" 
"SETROPTS RACLIST(TSOPROC) REFRESH "
"CONNECT  "||KEY_ADMIN||" GROUP(IZUUSER)" ,
   " OWNER(${instance-EKMF_ADMIN_SECURITY}) AUTH(USE) UACC(NONE)"

Say "Creating the database group"
"ADDGROUP "||DB_CURRENT_SCHEMA||" SUPGROUP(CCCAGRP) OMVS(AUTOGID)"
"CONNECT  "||WEB_UNAUTHENTICATED_USER||" GROUP("||DB_CURRENT_SCHEMA||")",
   " OWNER(CCCAGRP) AUTH(USE) UACC(NONE)"
"CONNECT  "||WEB_TASK_USER||" GROUP("||DB_CURRENT_SCHEMA||")",
   " OWNER(CCCAGRP) AUTH(USE) UACC(NONE)"
"CONNECT  "||AGENT_TASK_USER||" GROUP("||DB_CURRENT_SCHEMA||")",
   " OWNER(CCCAGRP) AUTH(USE) UACC(NONE)"
"CONNECT  ${instance-EKMF_ADMIN_DB} GROUP("||DB_CURRENT_SCHEMA||")",
   " OWNER(CCCAGRP) AUTH(USE) UACC(NONE)"
#end 

Say "Defining key prefix profile "||KEY_PREFIX||".** "
"RDEF CSFKEYS "||KEY_PREFIX||".** OWNER("||RACF_OWNER||") UACC(NONE) ICSF(SYMCPACFWRAP(YES),SYMCPACFRET(YES))"
"PERMIT "||KEY_PREFIX||".**  CLASS(CSFKEYS) ACCESS(CONTROL) ID(ACSPSGRP)"

Say "Refreshing CSFKEYS"
"SETROPTS RACLIST(CSFKEYS) REFRESH"
