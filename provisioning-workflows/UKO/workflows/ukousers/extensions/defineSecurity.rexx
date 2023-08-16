/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/

/***********************************************************************/
/* Creating the required user IDs and groups                           */
/***********************************************************************/

AGENT_STC_USER="${instance-UKO_AGENT_STC_USER}"
AGENT_STC_GROUP="${instance-UKO_AGENT_STC_GROUP}"

AGENT_CLIENT_USER="${instance-UKO_AGENT_CLIENT_USER}"
AGENT_CLIENT_GROUP="${instance-UKO_AGENT_CLIENT_GROUP}"

SERVER_STC_USER="${instance-UKO_SERVER_STC_USER}"
SERVER_TASK_GROUP="${instance-UKO_SERVER_STC_GROUP}"

SERVER_UNAUTHENTICATED_USER="${instance-UKO_UNAUTHENTICATED_USER}"
SERVER_UNAUTHENTICATED_GROUP="${instance-UKO_UNAUTHENTICATED_GROUP}"

KEY_ADMIN="${instance-UKO_KEY_ADMIN}"
KEY_ADMIN_GROUP="${instance-UKO_KEY_ADMIN_GROUP}"

DB_CURRENT_SCHEMA="${instance-DB_CURRENT_SCHEMA}"

KEY_PREFIX="${instance-UKO_KEY_PREFIX}"
RACF_OWNER="${instance-UKO_ADMIN_SECURITY}"

#if($!{instance-UKO_CREATE_GROUPS} == "TRUE" ) 
Say "Creating the required groups"
Say "Creating the Agent started task group"
"ADDGROUP "||AGENT_STC_GROUP||" SUPGROUP(SYS1) OMVS(AUTOGID)"
Say "Creating the Client group for authentication with the agent"
"ADDGROUP "||AGENT_CLIENT_GROUP||" SUPGROUP(SYS1) OMVS(AUTOGID)"
Say "Creating the Liberty started task group"
"ADDGROUP "||SERVER_TASK_GROUP||" SUPGROUP(SYS1) OMVS(AUTOGID)"
Say "Creating the unauthenticated user group for the Liberty server"
"ADDGROUP "||SERVER_UNAUTHENTICATED_GROUP||" SUPGROUP(SYS1) OMVS(AUTOGID)"
Say "Creating the key administrator group"
"ADDGROUP "||KEY_ADMIN_GROUP||" SUPGROUP(SYS1) OMVS(AUTOGID)"
#end

#if($!{instance-UKO_CREATE_USERIDS} == "TRUE" ) 
/***********************************************************************/
/* Creating all required user ids                                      */
/***********************************************************************/
/* TODO: we are re-using EKMFSGRP, EKMFUGRP, LIBSRVGP and WSCLGP */
/* temporary group names to fully test RACF setup */
/* or switch to userids instead of groups*/
/* all ICSF access is handled in the groups at the moment*/

Say "Creating the Agent started task user ID and group"
"ADDUSER "||AGENT_STC_USER||" NOPASSWORD",
   " DFLTGRP("||AGENT_STC_GROUP||") NAME('UKO agent')",
   " OMVS(AUTOUID PROGRAM('/bin/sh')",
   " HOME("||"'"||"/u/"||AGENT_STC_USER||"'"||"))"

Say "Creating the Client user for authentication with the agent"
"ADDUSER "||AGENT_CLIENT_USER||" NOPASSWORD",
   " DFLTGRP("||AGENT_CLIENT_GROUP||") NAME('UKO Client')",
   " OMVS(AUTOUID PROGRAM('/bin/sh')",
   " HOME("||"'"||"/u/"||AGENT_CLIENT_USER||"'"||"))"

Say "Creating the Liberty started task user ID and group"
"ADDUSER "||SERVER_STC_USER||" NOPASSWORD",
   " DFLTGRP("||SERVER_TASK_GROUP||") NAME('UKO Liberty SERVER')",
   " OMVS(AUTOUID PROGRAM('/bin/sh')",
   " HOME("||"'"||"/u/"||SERVER_STC_USER||"'"||"))"

Say "Adding the unauthenticated user ID for the Liberty server (WSGUEST by default)"
"ADDUSER "||SERVER_UNAUTHENTICATED_USER||" RESTRICTED NOOIDCARD NOPASSWORD",
   " DFLTGRP("||SERVER_UNAUTHENTICATED_GROUP||") NAME('WAS DEFAULT USER')",
   " OMVS(AUTOUID PROGRAM('/bin/sh')",
   " HOME("||"'"||"/u/"||SERVER_UNAUTHENTICATED_USER||"'"||")) "

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
   " OWNER(${instance-UKO_ADMIN_SECURITY}) AUTH(USE) UACC(NONE)"

Say "Creating the database group"
"ADDGROUP "||DB_CURRENT_SCHEMA||" SUPGROUP(CCCAGRP) OMVS(AUTOGID)"
"CONNECT  "||SERVER_UNAUTHENTICATED_USER||" GROUP("||DB_CURRENT_SCHEMA||")",
   " OWNER(CCCAGRP) AUTH(USE) UACC(NONE)"
"CONNECT  "||SERVER_STC_USER||" GROUP("||DB_CURRENT_SCHEMA||")",
   " OWNER(CCCAGRP) AUTH(USE) UACC(NONE)"
"CONNECT  "||AGENT_STC_USER||" GROUP("||DB_CURRENT_SCHEMA||")",
   " OWNER(CCCAGRP) AUTH(USE) UACC(NONE)"
"CONNECT  ${instance-UKO_ADMIN_DB} GROUP("||DB_CURRENT_SCHEMA||")",
   " OWNER(CCCAGRP) AUTH(USE) UACC(NONE)"
#end 

Say "Defining key prefix profile "||KEY_PREFIX||".** "
"RDEF CSFKEYS "||KEY_PREFIX||".** OWNER("||RACF_OWNER||") UACC(NONE) ICSF(SYMCPACFWRAP(YES),SYMCPACFRET(YES))"
"PERMIT "||KEY_PREFIX||".**  CLASS(CSFKEYS) ACCESS(CONTROL) ID(ACSPSGRP)"

Say "Refreshing CSFKEYS"
"SETROPTS RACLIST(CSFKEYS) REFRESH"
